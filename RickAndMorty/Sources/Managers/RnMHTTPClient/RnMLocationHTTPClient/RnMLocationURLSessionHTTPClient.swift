import Foundation

// MARK: - Rick and Morty location URL session HTTP client

/// Класс, реализующий интерфейс HTTP-клиента
/// для работы с API локаций из вселенной `"Rick and Morty"` на основе `URLSession`.
final class RnMLocationURLSessionHTTPClient: RnMURLSessionHTTPClient, RnMLocationHTTPClient {
    
    // MARK: Properties
    
    let session: URLSession
    let decoder: HTTPResponseDecoder
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - session: сессия, используемая для выполнения сетевых запросов.
    ///   - decoder: декодер для преобразования данных ответов.
    init(
        session: URLSession = URLSession.shared,
        decoder: HTTPResponseDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    // MARK: Functions
    
    func getLocation(with id: Int) async throws(HTTPRequestError) -> RnMLocationDTO {
        let endpoint = RnMLocationHTTPRequestEndpoint.getLocationWitId(id)
        let location: RnMLocationDTO = try await execute(with: endpoint)
        
        return location
    }
    
    func getLocations(with ids: [Int]) async throws(HTTPRequestError) -> [RnMLocationDTO] {
        let endpoint = RnMLocationHTTPRequestEndpoint.getLocationsWithIds(ids)
        let locations: [RnMLocationDTO] = try await execute(with: endpoint)
        
        return locations
    }
    
    func getLocations(with filter: RnMLocationHTTPRequestFilter?) async throws(HTTPRequestError) -> [RnMLocationDTO] {
        let endpoint = RnMLocationHTTPRequestEndpoint.getLocationsWithFilter(filter)
        let locations: RnMLocationsDTO = try await execute(with: endpoint)
        
        return locations.list
    }
}
