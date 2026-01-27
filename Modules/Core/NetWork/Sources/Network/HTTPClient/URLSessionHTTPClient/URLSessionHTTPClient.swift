import Foundation

// MARK: - URL session HTTP client

/// Актор, реализующий интерфейс `HTTP`-клиента на основе `URLSession`.
public actor URLSessionHTTPClient {
    
    // MARK: Properties
    
    /// Сессия для выполнения сетевых запросов.
    private let session: URLSession
    /// Декодер для преобразования данных ответов.
    private let decoder: HTTPResponseDecoder
    
    // MARK: Initialization
    
    /// Создает новый экземпляр актора.
    /// - Parameters:
    ///   - session: сессия, используемая для выполнения сетевых запросов.
    ///   - decoder: декодер для преобразования данных ответов.
    public init(
        session: URLSession = URLSession.shared,
        decoder: HTTPResponseDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }
}

// MARK: - HTTP client protocol implementation

extension URLSessionHTTPClient: HTTPClient {
    
    public func execute<T: Decodable & Sendable>(
        with httpRequestEndpoint: HTTPRequestEndpoint
    ) async throws(HTTPRequestError) -> T {
        do {
            let urlRequest = try httpRequestEndpoint.makeURLRueqset()
            let (data, response) = try await session.data(for: urlRequest)
            
            guard
                let response = response as? HTTPURLResponse
            else { throw HTTPRequestError.emptyResponse }
            
            switch response.statusCode {
            case 200...299:
                do { return try decoder.decode(T.self, from: data) }
                catch {
                    throw HTTPRequestError.JSON.decode(
                        type: "\(T.self)",
                        description: error.localizedDescription
                    )
                }
            
            default: throw HTTPRequestError.invalidStatusCode(response.statusCode)
            }
        }
        catch let error as HTTPRequestError { throw error }
        catch URLError.notConnectedToInternet { throw HTTPRequestError.networkDown }
        catch { throw HTTPRequestError.unknown(error.localizedDescription) }
    }
}
