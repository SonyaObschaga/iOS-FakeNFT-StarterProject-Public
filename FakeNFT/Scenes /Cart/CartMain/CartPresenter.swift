import Foundation

protocol CartView: AnyObject {
    func reload()
    func updateTotal(nftCount: Int, totalPrice: String)
    func showDelete(at indexPath: IndexPath)
    func showSortOptions()
    func updateCart(with nftIds: [String])
    func showLoading()
    func hideLoading()
}

final class CartPresenter {
    
    private weak var view: CartView?
    private let sortManager = CartSortPreferenceManager()
    
    private let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )
    private var nftIds: [String] = []
    
    var currentSortOption: CartSortOption {
        sortManager.load()
    }
    
    private var nftData: [Nft] = []
    
    init(view: CartView) {
        self.view = view
        loadCart()
        applySort(option: currentSortOption)
    }
    
    var rows: Int { nftData.count }
    
    func viewWillAppear() {
        loadCart()
    }
    
    func nft(at indexPath: IndexPath) -> Nft {
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
    
    func loadCart() {
        view?.showLoading()
        
        servicesAssembly.cartOredrService.loadCart() { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let ids):
                    self?.nftIds = ids
                    ids.forEach { self?.loadNft(id: $0) }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func loadNft(id: String) {
        servicesAssembly.nftService.loadNft(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nft):
                    self?.nftData.append(nft)
                    self?.applySort(option: self?.currentSortOption ?? .price)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func sortTapped() {
        view?.showSortOptions()
    }
}
