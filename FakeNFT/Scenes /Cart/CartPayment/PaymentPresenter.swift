import Foundation

protocol PaymentView: AnyObject {
    func reload()
}

final class PaymentPresenter {

    private weak var view: PaymentView?
    private let currencies = mockCurrencies
    private(set) var selected: PaymentCurrency?

    init(view: PaymentView) {
        self.view = view
    }

    var count: Int { currencies.count }

    func model(at indexPath: IndexPath) -> PaymentCurrency {
        currencies[indexPath.item]
    }

    func select(at indexPath: IndexPath) {
        selected = currencies[indexPath.item]
        view?.reload()
    }
}
