import Foundation

protocol PaymentView: AnyObject {
    func reload()
    func reloadItems(oldIndex: Int?, newIndex: Int)
}

final class PaymentPresenter {
    
    private weak var view: PaymentView?
    private let currencies = mockCurrencies
    private(set) var selected: PaymentCurrency?
    private var previousSelectedIndex: Int?
    
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
}
