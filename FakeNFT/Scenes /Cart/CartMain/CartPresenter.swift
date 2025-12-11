import Foundation

protocol CartView: AnyObject {
    func reload()
    func updateTotal(nftCount: Int, totalPrice: String)
    func showDelete(at indexPath: IndexPath)
    func showSortOptions()
}

final class CartPresenter {
    
    private weak var view: CartView?
    private let sortManager = CartSortPreferenceManager()
    
    var currentSortOption: CartSortOption {
        sortManager.load()
    }
    
    private var nftData: [TestNFTModel] = [
        TestNFTModel(name: "Atheen", rating: 2, price: 5.15),
        TestNFTModel(name: "Bulbasaur", rating: 3, price: 2.22),
        TestNFTModel(name: "Greena", rating: 1, price: 3.09)
    ]
    
    init(view: CartView) {
        self.view = view
        applySort(option: currentSortOption)
    }
    
    // MARK: - Public
    
    var rows: Int { nftData.count }
    
    func model(at indexPath: IndexPath) -> TestNFTModel {
        nftData[indexPath.row]
    }
    
    func delete(at indexPath: IndexPath) {
        nftData.remove(at: indexPath.row)
        view?.reload()
        recalcTotal()
    }
    
    func recalcTotal() {
        let total = nftData.reduce(0) { $0 + $1.price }
        let totalString = String(total).replacingOccurrences(of: ".", with: ",")
        view?.updateTotal(nftCount: nftData.count, totalPrice: totalString)
    }
    
    func handleDeleteTap(at indexPath: IndexPath) {
        view?.showDelete(at: indexPath)
    }
    
    
    func applySort(option: CartSortOption) {
        sortManager.save(option)

        switch option {
        case .price:
            nftData.sort { $0.price < $1.price }
        case .rating:
            nftData.sort { $0.rating > $1.rating }
        case .name:
            nftData.sort { $0.name.lowercased() < $1.name.lowercased() }
        }

        view?.reload()
        recalcTotal()
    }
    
    func sortTapped() {
        view?.showSortOptions()
    }
}
