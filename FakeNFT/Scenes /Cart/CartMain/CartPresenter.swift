import Foundation

protocol CartView: AnyObject {
    func reload()
    func updateTotal(nftCount: Int, totalPrice: String)
    func showDelete(at indexPath: IndexPath)
    func showSortOptions()
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
    }
    
    var rows: Int { nftData.count }
    
    var currentNftIds: [String] {
        nftIds
    }
    
    func viewWillAppear() {
        loadCart()
        applySort(option: currentSortOption)
    }
    
    func nft(at indexPath: IndexPath) -> Nft {
        nftData[indexPath.row]
    }
    
    func delete(nftId: String) {
        guard let index = nftData.firstIndex(where: { $0.id == nftId }) else {
                return
            }

            nftData.remove(at: index)
            nftIds.removeAll { $0 == nftId }

            view?.reload()
            recalcTotal()
            updateOrderAfterDelete()
    }
    
    func recalcTotal() {
        let total = nftData.reduce(0) { $0 + $1.price }
        let totalString = String(format: "%.2f", total).replacingOccurrences(of: ".", with: ",")
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
        
        servicesAssembly.cartGetOrderService.loadCart() { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let ids):
                    self.nftIds = ids
                    self.nftData.removeAll()
                    self.view?.reload()
                    self.recalcTotal()
                    
                    guard !ids.isEmpty else {
                        self.view?.hideLoading()
                        return
                    }
                    
                    let group = DispatchGroup()
                    
                    ids.forEach { id in
                        group.enter()
                        self.loadNft(id: id) {
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: .main) {
                        self.view?.hideLoading()
                    }
                    
                case .failure(let error):
                    print(error)
                    self.view?.hideLoading()
                }
            }
        }
    }
    
    private func loadNft(id: String, completion: (() -> Void)? = nil) {
        servicesAssembly.nftService.loadNft(id: id) { [weak self] result in
            DispatchQueue.main.async {
                defer { completion?() }
                guard let self else { return }
                
                switch result {
                case .success(let nft):
                    guard !(self.nftData.contains(where: { $0.id == nft.id })) else { return }
                    self.nftData.append(nft)
                    self.applySort(option: self.currentSortOption)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func sortTapped() {
        view?.showSortOptions()
    }
    
    func updateOrderAfterDelete() {
        view?.showLoading()
        
        servicesAssembly.updateAndPayOrderService.updateOrder(nftIds: nftIds) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                self.view?.hideLoading()
                
                switch result {
                case .success:
                    print("[CartPresenter/updateOrderAfterDelete]: Deleting nft success")
                    self.view?.reload()
                    self.recalcTotal()
                    
                case .failure(let error):
                    print("[CartPresenter/updateOrderAfterDelete]: Failed to delete nft: \(error)")
                }
            }
        }
    }
}
