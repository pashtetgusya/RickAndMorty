import Foundation

// MARK: - HTTP request error

/// Перечень ошибок загрузки изображений.
enum ImageLoadError: LocalizedError {
    
    // MARK: Cases
    
    /// Отсутствует интернет-соединение.
    case networkDown
    
    /// Получен пустой ответ.
    case emptyResponse
    /// Получен невалидный статус-код.
    case invalidStatusCode(_ statusCode: Int)
    
    /// Неизвестная ошибка.
    case unknown(_ description: String)
    
    // MARK: Properties
    
    var errorDescription: String? {
        switch self {
        case .networkDown: "Connection Lost"
        case .emptyResponse: "Empty Response"
        case .invalidStatusCode(let statusCode): "Server returned invalid status: \(statusCode)"
        case .unknown(let description): "Unknown: \(description)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkDown: "Check Wi-Fi or cellular"
        
        default: "Please try again later"
        }
    }
}
