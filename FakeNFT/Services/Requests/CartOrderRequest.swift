import Foundation

struct CartOrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/api/v1/orders/1")
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
