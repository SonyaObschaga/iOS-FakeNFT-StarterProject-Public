struct PaymentCurrency: Decodable {
    let title: String
    let name: String
    let imageURLString: String
    let id: Int

    private enum CodingKeys: String, CodingKey {
        case title
        case name
        case imageURLString = "image"
        case id
    }
}
