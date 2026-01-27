import Foundation
import NetWork

// MARK: - Base locations repository

/// Класс, реализующий интерфейс репозитория
/// для получения локаций из вселенной `"Rick and Morty"`.
public final class BaseLocationsRepository {
    
    // MARK: Properties
    
    /// `HTTP`-клиент для выполнения сетевых запросов.
    private let httpClient: HTTPClient
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter httpClient: `HTTP`-клиент для выполнения сетевых запросов.
    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
}

// MARK: - Locations repository protocol implementation

extension BaseLocationsRepository: LocationsRepository {
    
    public func getLocation(
        with id: Int
    ) async throws(HTTPRequestError) -> LocationDTO {
        let endpoint = LocationsHTTPRequestEndpoint.getLocationWitId(id)
        let location: LocationDTO = try await httpClient.execute(with: endpoint)
        
        return location
    }
    
    public func getLocations(
        with ids: [Int]
    ) async throws(HTTPRequestError) -> [LocationDTO] {
        let endpoint = LocationsHTTPRequestEndpoint.getLocationsWithIds(ids)
        let locations: [LocationDTO] = try await httpClient.execute(with: endpoint)
        
        return locations
    }
    
    public func getLocations(
        with filter: LocationsHTTPRequestFilter?
    ) async throws(HTTPRequestError) -> [LocationDTO] {
        let endpoint = LocationsHTTPRequestEndpoint.getLocationsWithFilter(filter)
        let locations: LocationsDTO = try await httpClient.execute(with: endpoint)
        
        return locations.list
    }
}
