import Foundation

protocol CartView: AnyObject {
    func reload()
    func updateTotal(nftCount: Int, totalPrice: String)
    func showDelete(at indexPath: IndexPath)
}

final class CartPresenter {

    private weak var view: CartView?
    private var nftData: [TestNFTModel] = [
        TestNFTModel(name: "Atheen", rating: 5, price: 1.15),
        TestNFTModel(name: "Bulbasaur", rating: 3, price: 2.22),
        TestNFTModel(name: "Greena", rating: 1, price: 3.09)
    ]

    init(view: CartView) {
        self.view = view
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
}
