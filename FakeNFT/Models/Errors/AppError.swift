import Foundation

enum AppError {
    case setCurrency
    case payment
    
    var title: String {
        switch self {
        case .setCurrency:
            NSLocalizedString("Error.setCurrency", comment: "")
        case .payment:
            NSLocalizedString("Payment.error", comment: "")
        }
    }

    var retryTitle: String {
        NSLocalizedString("Error.repeat", comment: "")
    }

    var cancelTitle: String {
        NSLocalizedString("Common.cancel", comment: "")
    }
}
