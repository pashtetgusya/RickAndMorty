import Foundation

// MARK: - HTTP request error

/// Перечень ошибок HTTP-запросов.
enum HTTPRequestError: LocalizedError {
    
    // MARK: Cases
    
    /// Отсутствует интернет-соединение.
    case networkDown
    
    /// Невозможно создать валидный URL из переданной строки.
    case invalidURL(_ urlString: String)
    /// Сервер вернул пустой ответ.
    case emptyResponse
    /// Сервер вернул невалидный статус-код.
    case invalidStatusCode(_ statusCode: Int)
    
    /// Неизвестная ошибка.
    case unknown(_ description: String)
    
    // MARK: Properties
    
    var errorDescription: String? {
        switch self {
        case .networkDown: "Connection Lost"
        case .invalidURL(let urlString): "Invalid URL: \(urlString)"
        case .emptyResponse: "Empty Response"
        case .invalidStatusCode(let statusCode): "Server returned invalid status: \(statusCode)"
        case .unknown(let description): "Unknown: \(description)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkDown: "Check Wi-Fi or cellular"
        case .invalidURL: "Check for special characters"
        
        default: "Please try again later"
        }
    }
}

// MARK: - HTTP request JSON error

extension HTTPRequestError {
    
    /// Перечень ошибок работы с JSON форматом.
    enum JSON: LocalizedError {
        
        // MARK: Cases
        
        /// Ошибка кодирования модели в JSON формат.
        case encode(_ error: Error)
        /// Ошибка декодирования модели из JSON формата.
        case decode(_ error: Error)
        
        // MARK: Properties
        
        var errorDescription: String? {
            switch self {
            case .encode: "Data encoding failed"
            case .decode: "Data decoding failed"
            }
        }
        
        var failureReason: String? {
            switch self {
            case .encode(let error), .decode(let error):
                error.localizedDescription
            }
        }
    }
}
