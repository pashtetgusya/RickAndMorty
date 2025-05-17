import Foundation

// MARK: - Rick and Morty URL session HTTP client protocol

/// Интерфейс HTTP-клиента для работы с API вселенной `"Rick and Morty"` на основе `URLSession`.
protocol RnMURLSessionHTTPClient: HTTPClient {
    
    // MARK: Properties
    
    /// Сессия для выполнения сетевых запросов.
    var session: URLSession { get }
}

// MARK: - Rick and Morty URL session HTTP client protocol base implementation

extension RnMURLSessionHTTPClient {
    
    func execute<T: Decodable>(
        with httpRequestEndpoint: HTTPRequestEndpoint
    ) async throws (HTTPRequestError) -> T {
        do {
            let urlRequest = try httpRequestEndpoint.makeURLRueqset()
            let (data, response) = try await session.data(for: urlRequest)
            
            guard
                let response = response as? HTTPURLResponse
            else { throw HTTPRequestError.emptyResponse }
            
            switch response.statusCode {
            case 200...299:
                do { return try decoder.decode(T.self, from: data) }
                catch { throw HTTPRequestError.JSON.decode(error) }
            
            default: throw HTTPRequestError.invalidStatusCode(response.statusCode)
            }
        }
        catch let error as HTTPRequestError { throw error }
        catch URLError.notConnectedToInternet { throw .networkDown }
        catch { throw .unknown(error.localizedDescription) }
    }
}
