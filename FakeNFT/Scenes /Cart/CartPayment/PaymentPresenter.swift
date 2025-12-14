import Foundation

protocol PaymentView: AnyObject {
    func reload()
    func reloadItems(oldIndex: Int?, newIndex: Int)
    func showLoading()
    func hideLoading()
    func showSuccess()
    func showError(_ error: AppError)
}

final class PaymentPresenter {
    
    private weak var view: PaymentView?
    private let currencies = mockCurrencies
    private(set) var selected: PaymentCurrency?
    private var previousSelectedIndex: Int?
    private let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )
    
    init(view: PaymentView) {
        self.view = view
    }
    
    var count: Int { currencies.count }
    
    func model(at indexPath: IndexPath) -> PaymentCurrency {
        currencies[indexPath.item]
    }
    
    func select(at indexPath: IndexPath) {
        let newIndex = indexPath.item
        let oldIndex = previousSelectedIndex
        
        selected = currencies[newIndex]
        previousSelectedIndex = newIndex
        
        view?.reloadItems(oldIndex: oldIndex, newIndex: newIndex)
    }
    
    func proceedPayment() {
        view?.showLoading()
        
        // пока нет работы с сетью - делаем небольшую задержку для показа ProgressHUD
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.view?.hideLoading()
            self?.view?.showError(.payment)
        }
    }
    
    func changeCurrency(id: String) {
        view?.showLoading()

        servicesAssembly.setCurrencyService.setCurrency(currencyId: id) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()

                if case .failure = result {
                    self?.view?.showError(.setCurrency)
                }
            }
        }
    }
    
    func retry(for error: AppError) {
        switch error {
        case .setCurrency:
            if let id = selected?.id {
                let stringId = String(id)
                changeCurrency(id: stringId)
            }

        case .payment:
            proceedPayment()
        }
    }
}
