import Foundation

// MARK: - Image load error

/// Энам, описывающий перечень возможных ошибок при выполнении загрузки изображений.
public enum ImageLoadError: LocalizedError {
    
    // MARK: Cases
    
    /// Отсутствует интернет-соединение.
    case networkDown
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
        case .emptyResponse,
             .invalidStatusCode,
             .unknown: "Пожалуйста попробуйте позже."
        }
    }
}
