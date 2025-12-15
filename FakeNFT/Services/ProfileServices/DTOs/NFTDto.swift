//
//  NFTDto.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 24/11/25.
//

import Foundation

struct NFTDto: Encodable, Decodable {
    let createdAt: Date
    let name: String
    let images: [String]
    let rating: Int?
    let description: String?
    let price: Double
    let author: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "CreatedAt"
        case name = "Name"
        case images = "Images"
        case rating = "Rating"
        case description = "Description"
        case price = "Price"
        case author = "Author"
        case id = "Id"
        }
    
    // Статический метод для создания декодера
        static func createJSONDecoder() -> JSONDecoder {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'['GMT']"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            return decoder
        }
        
        // Метод для декодирования JSON данных
        static func decodeFromJSON(_ jsonData: Data) throws -> NFTDto {
            let decoder = createJSONDecoder()
            return try decoder.decode(NFTDto.self, from: jsonData)
        }
    
        static func decodeFromJSONArray(_ jsonData: Data) throws -> [NFTDto] {
            let decoder = createJSONDecoder()
            return try decoder.decode([NFTDto].self, from: jsonData)
        }
}
