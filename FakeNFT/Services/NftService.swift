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
    private let userId: String
    
    init(networkClient: NetworkClient, storage: NftStorage, userId: String) {
        self.storage = storage
        self.networkClient = networkClient
        self.userId = userId
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
        let profileRequest = ProfileRequest(userId: userId)
        networkClient.send(request: profileRequest, type: ProfileResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                var updatedLikes = profile.likes
                
                if isLiked {
                    if !updatedLikes.contains(nftId) {
                        updatedLikes.append(nftId)
                    }
                } else {
                    updatedLikes.removeAll { $0 == nftId }
                }
                
                let updateRequest = UpdateProfileRequest(
                    userId: self.userId,
                    likes: updatedLikes
                )
                
                self.networkClient.send(request: updateRequest, type: ProfileResponse.self) { result in
                    switch result {
                    case .success:
                        if var nft = self.storage.getNft(with: nftId) {
                            nft.isLiked = isLiked
                            self.storage.saveNft(nft)
                        }
                        completion(.success(()))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
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

struct ProfileRequest: NetworkRequest {
    let userId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(userId)")
    }
    
    var httpMethod: HttpMethod { .get }
    var dto: (any Dto)? { nil }
}

struct UpdateProfileRequest: NetworkRequest {
    let userId: String
    let likes: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(userId)")
    }
    
    var httpMethod: HttpMethod { .put }
    
    var dto: (any Dto)? {
        UpdateProfileDto(likes: likes)
    }
}

struct UpdateProfileDto: Dto {
    let likes: [String]
    
    func asDictionary() -> [String: String] {
        if likes.isEmpty {
            return ["likes": "[]"]
        }
        
        let likesString = likes.joined(separator: ",")
        return ["likes": likesString]
    }
}

// Модель ответа профиля
struct ProfileResponse: Decodable {
    let id: String
    let likes: [String]
}
