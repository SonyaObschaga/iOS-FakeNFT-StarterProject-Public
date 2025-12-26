final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage,
            userId: "1"
        )
    }
    
    var collectionsService: CollectionsService {
            CollectionsServiceImpl(networkClient: networkClient)
        }
    
    var orderService: OrderService {
        OrderServiceImpl(networkClient: networkClient)
    }
    
    var currencyService: CurrencyService {
        CurrencyServiceImpl(networkClient: networkClient)
    }
    
    private let profileStorage: ProfileStorage = ProfileStorageImpl()
    lazy var modelServiceAgent: FakeNFTModelServiceAgentProtocol = {
        if FakeNFTModelServiceAgent.dataSourceType == .webAPI {
            return FakeNFTModelServiceAgent(servicesAssembly: self)
        } else {
            return FakeNFTMockDataServiceAgent()
        }
    }()
    
    var profileService: ProfileService {
        ProfileServiceImpl(networkClient: networkClient, storage: profileStorage)
    }
    
    var cartGetOrderService: GetCartService {
        CartGetOrderServiceImpl(networkClient: networkClient)
    }
    
    var setCurrencyService: SetCurrencyService {
        SetCurrencyServiceImpl(networkClient: networkClient)
    }
    
    var updateAndPayOrderService: UpdateAndPayService {
        UpdateAndPayOrderServiceImpl(networkClient: networkClient)
    }
}
