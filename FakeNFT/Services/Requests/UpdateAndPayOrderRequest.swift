import Foundation

struct UpdateAndPayOrderDto: Dto {
    let nftIds: [String]

    func asDictionary() -> [String: String] {
        [
            "nfts": nftIds.joined(separator: ",")
        ]
    }
}

struct UpdateAndPayOrderRequest: NetworkRequest {

    struct DtoModel: Dto {
        let nftIds: [String]

        func asDictionary() -> [String: String] {
            [
                "nfts": nftIds.joined(separator: ",")
            ]
        }
    }

    let nftIds: [String]
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod { .put }

    var dto: Dto? {
        DtoModel(nftIds: nftIds)
    }

    var headers: [String: String] {
        [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "X-Practicum-Mobile-Token": RequestConstants.token
        ]
    }
}
