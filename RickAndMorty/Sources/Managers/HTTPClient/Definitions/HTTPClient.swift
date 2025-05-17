import Foundation

// MARK: - HTTP client protocol

/// Интерфейс HTTP-клиента.
protocol HTTPClient: Sendable {
    
    // MARK: Properties
    
    /// Декодер для преобразования данных ответов.
    var decoder: HTTPResponseDecoder { get }
    
    // MARK: Functions
    
    /// Выполняет базовый HTTP-запрос к указанному endpint'у.
    /// - Parameters:
    ///   - httpRequestEndpoint: endpoint запроса, реализующий `HTTPRequestEndpoint`.
    ///     Содержит всю информацию для формирования запроса (URL, метод, заголовки и т.д.).
    /// - Returns: Декодированный объект указанного типа `T`.
    /// - Throws: `HTTPRequestError` в случае возникновения ошибок (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func execute<T: Decodable>(with httpRequestEndpoint: HTTPRequestEndpoint) async throws (HTTPRequestError) -> T
}
