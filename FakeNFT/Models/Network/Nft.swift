import Foundation

struct Nft: Decodable {
    let id: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    
    public static var EmptyNft: Nft = Nft(id:"", images: [], rating:0, description:"", price:0, author:"")
    
    public func NftModelObject() -> NFTModel {
        var m = NFTModel()
        m.createdAt = Date()
        m.images = [] //self.images
        for image in self.images {
            m.images.append(image.absoluteString)
        }
        m.rating = self.rating
        m.description = self.description
        m.price = self.price
        
        m.author = self.author
        m.name = self.author // !!!
        m.id = self.id
        return m
    }
}


/*
 var createdAt: Date
 var name: String = ""
 var images: [String] = []
 var rating: Int? = 0
 var description: String? = ""
 var price: Float = 0
 var author: String = ""
 var id: String = ""
 var isLiked: Bool = false

 */
