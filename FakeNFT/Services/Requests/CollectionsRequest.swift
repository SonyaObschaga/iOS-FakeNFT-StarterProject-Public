import Foundation

struct CollectionsRequest: NetworkRequest {
    let page: Int
    let size: Int
    
    init(page: Int = 0, size: Int = 100) {
        self.page = page
        self.size = size
    }
    
    var endpoint: URL? {
        var components = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/nft")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)")
        ]
        return components?.url
    }
    
    var dto: Dto?
}
