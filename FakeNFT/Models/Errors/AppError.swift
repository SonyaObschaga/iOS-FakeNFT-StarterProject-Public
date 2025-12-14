enum AppError {
    case setCurrency
    case payment
    
    var title: String {
        switch self {
        case .setCurrency:
            return "Не удалось выбрать валюту"
        case .payment:
            return "Не удалось произвести оплату"
        }
    }
    
    var retryTitle: String {
        "Повторить"
    }
    
    var cancelTitle: String {
        "Отмена"
    }
}
