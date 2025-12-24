import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func updateLikeStatus(for nftId: String, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func toggleLikeStatus(for nftId: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

final class NftServiceImpl: NftService {
    private let networkClient: NetworkClient
    private let storage: NftStorage
    
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }
        
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateLikeStatus(for nftId: String, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        print("🌐 Sending like request for NFT \(nftId), isLiked: \(isLiked)")
        
        let request = UpdateLikeRequest(nftId: nftId, isLiked: isLiked)
        
        networkClient.send(request: request, type: EmptyResponse.self) { result in
            switch result {
            case .success:
                print("✅ Server response: Like status updated successfully")
                
                if var nft = self.storage.getNft(with: nftId) {
                    nft.isLiked = isLiked
                    self.storage.saveNft(nft)
                    print("💾 Storage updated for NFT \(nftId)")
                }
                
                completion(.success(()))
                
            case .failure(let error):
                print("❌ Server error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func toggleLikeStatus(for nftId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        if let nft = storage.getNft(with: nftId) {
            let newLikeStatus = !(nft.isLiked ?? false)
            
            updateLikeStatus(for: nftId, isLiked: newLikeStatus) { result in
                switch result {
                case .success:
                    completion(.success(newLikeStatus))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            loadNft(id: nftId) { [weak self] result in
                switch result {
                case .success(let nft):
                    let newLikeStatus = !(nft.isLiked ?? false)
                    self?.updateLikeStatus(for: nftId, isLiked: newLikeStatus) { result in
                        switch result {
                        case .success:
                            completion(.success(newLikeStatus))
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

struct EmptyResponse: Decodable {}
