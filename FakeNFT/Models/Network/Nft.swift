import Foundation

struct Nft: Decodable {
    let id: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    
    public static var emptyNft: Nft = Nft(id:"", images: [], rating:0, description:"", price:0, author:"")
    
    public func NftModelObject() -> NFTModel {
        var m = NFTModel()
        m.createdAt = Date()
        m.images = []
        m.images = images.map { $0.absoluteString }
        m.rating = self.rating
        m.description = self.description
        m.price = self.price
        
        m.author = self.author
        m.name = self.author
        m.id = self.id
        return m
    }
}
