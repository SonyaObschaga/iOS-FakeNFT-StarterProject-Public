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
            storage: nftStorage
        )
    }
    
    private let profileStorage: ProfileStorage = ProfileStorageImpl()
    lazy var modelServiceAgent: FakeNFTModelServiceAgentProtocol = {
        if FakeNFTService.dataSourceType == .webAPI {
            return FakeNFTModelServiceAgent(servicesAssembly: self)
        } else {
            return FakeNFTService()
        }
    }()
    var profileService: ProfileService { //Protocol {
        ProfileServiceImpl(networkClient: networkClient, storage: profileStorage)
    }
    
}
