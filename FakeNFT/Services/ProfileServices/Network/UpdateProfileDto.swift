import Foundation

struct UpdateProfileDto: Dto {
    let likes: [String]
    
    func asDictionary() -> [String: String] {
        let likesString = likes.joined(separator: ",")
        return ["likes": likesString]
    }
}
