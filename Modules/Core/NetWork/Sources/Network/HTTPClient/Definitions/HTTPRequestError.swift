import Foundation

// MARK: - HTTP request error

/// Энам, описывающий перечень возможных ошибок при выполнении `HTTP`-запросов.
public enum HTTPRequestError: LocalizedError {
    
    // MARK: Cases
    
    /// Отсутствует интернет-соединение.
    case networkDown
    /// Невозможно создать валидный `URL` из переданной строки.
    case invalidURL(_ urlString: String)
    /// Сервер вернул пустой ответ.
    case emptyResponse
    /// Сервер вернул невалидный статус-код.
    case invalidStatusCode(_ statusCode: Int)
    /// Произошла неизвестная ошибка.
    case unknown(_ description: String)
    
    // MARK: Properties
    
    public var errorDescription: String? {
        switch self {
        case .networkDown: 
            "Отсутствует интернет-соединение."
        case .invalidURL(let urlString):
            "Невозможно создать валидный `URL` из переданной строки: \(urlString)."
        case .emptyResponse:
            "Сервер вернул пустой ответ."
        case .invalidStatusCode(let statusCode):
            "Сервер вернул невалидный статус-код: \(statusCode)."
        case .unknown(let description): 
            "Произошла неизвестная ошибка. \(description)"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .networkDown: "Проверьте подключение к сети."
        case .invalidURL: "Проверьте валидность переданной `URL` строки."
        case .emptyResponse,
             .invalidStatusCode,
             .unknown: "Пожалуйста попробуйте позже."
        }
    }
}
