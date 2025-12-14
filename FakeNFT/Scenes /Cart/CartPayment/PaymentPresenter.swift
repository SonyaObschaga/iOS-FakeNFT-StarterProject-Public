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
    
    private var nftIds: [String]
    
    init(view: PaymentView, nftIds: [String]) {
        self.view = view
        self.nftIds = nftIds
    }
    
    var count: Int { currencies.count }
    
    func model(at indexPath: IndexPath) -> PaymentCurrency {
        currencies[indexPath.item]
    }
    
    func select(at indexPath: IndexPath) {
        let newIndex = indexPath.item
        let oldIndex = previousSelectedIndex
        let stringNewIndex = String(newIndex)
        
        selected = currencies[newIndex]
        previousSelectedIndex = newIndex
        DispatchQueue.main.async { [weak self] in
            self?.view?.showLoading()
            self?.changeCurrency(id: stringNewIndex)
        }
        
        view?.reloadItems(oldIndex: oldIndex, newIndex: newIndex)
    }
    
    func proceedPayment() {
        if !nftIds.isEmpty {
            print("[PaymentPresenter/proceedPayment]: NFT list is empty!")
            return
        }
        view?.showLoading()
        
        servicesAssembly.updateAndPayOrderService.updateOrder(nftIds: nftIds) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                self.view?.hideLoading()
                
                switch result {
                case .success:
                    print("[PaymentPresenter/proceedPayment]: Order successfully payed with NFTs: \(self.nftIds)")
                    self.nftIds = []
                    self.servicesAssembly.updateAndPayOrderService.updateOrder(nftIds: self.nftIds, completion: {_ in })
                    self.view?.showSuccess()
                    
                case .failure(let error):
                    print("[PaymentPresenter/proceedPayment]: Failed to pay order: \(error)")
                    self.view?.showError(.payment)
                }
            }
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
