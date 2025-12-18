import Foundation

typealias CollectionItemsCompletion = (Result<[CollectionItemResponse], Error>) -> Void

protocol CollectionService {
    func fetchCollections(completion: @escaping CollectionItemsCompletion)
}

final class CollectionServiceImpl: CollectionService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCollections(completion: @escaping CollectionItemsCompletion) {
        let request = CollectionsRequest()
        if let url = request.endpoint {
            print("🌐 Requesting collections from: \(url.absoluteString)")
        }
        networkClient.send(request: request, type: [CollectionItemResponse].self) { result in
            switch result {
            case .success(let items):
                print("✅ Successfully loaded \(items.count) collection items")
                if items.isEmpty {
                    print("⚠️ Warning: API returned empty array. Check the raw response above.")
                }
                completion(.success(items))
            case .failure(let error):
                print("❌ Failed to load collections: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
