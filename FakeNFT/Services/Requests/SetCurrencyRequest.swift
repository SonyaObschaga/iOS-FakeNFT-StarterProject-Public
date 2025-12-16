import Foundation

struct SetCurrencyRequest: NetworkRequest {
    var id: String
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/api/v1/orders/1/payment/" + id)
    }

    var httpMethod: HttpMethod { .get }

    var dto: Dto? { nil }

    var headers: [String: String] {
        [
            "Accept": "application/json",
            "X-Practicum-Mobile-Token": RequestConstants.token
        ]
    }
}
