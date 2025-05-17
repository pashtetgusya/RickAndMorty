import Foundation

// MARK: - Rick and Morty location HTTP request endpoint

/// Перечень endpoint'ов для HTTP-запросов в
/// API локаций из вселенной `"Rick and Morty"`.
enum RnMLocationHTTPRequestEndpoint: HTTPRequestEndpoint {
    
    // MARK: Cases
    
    /// Endpoint получения полной информации о локации по переданному идентификатору.
    /// - Parameter id: уникальный идентификатор локации.
    /// - Returns: endpoint для запроса вида `/api/location/{id}`.
    case getLocationWitId(_ id: Int)
    /// Endpoint получения полной информации о локациях по переданному списку идентификаторов.
    /// - Parameter ids: список идентификаторов локаций.
    /// - Returns: endpoint для запроса вида `/api/location/[id1,id2,...]`.
    case getLocationsWithIds(_ ids: [Int])
    /// Endpoint получения полной информации о локациях.
    /// - Parameter filter: параметры фильтрации.
    /// - Returns: Endpoint для запроса вида `/api/location` с query-параметрами.
    case getLocationsWithFilter(_ filter: RnMLocationHTTPRequestFilter?)
    
    // MARK: Properties
    
    var method: HTTPRequestMethod { .get }
    
    var scheme: HTTPRequestScheme { .https }
    var host: String { RnMHTTPRequestConstants.host }
    var path: String {
        switch self {
        case .getLocationWitId(let id): "/api/location/\(id)"
        case .getLocationsWithIds(let ids): "/api/location/\(ids)"
        case .getLocationsWithFilter: "/api/location"
        }
    }
    
    var headers: [String : String]? { nil }
    var queryItems: [String : String]? {
        switch self {
        case .getLocationWitId: return nil
        case .getLocationsWithIds: return nil
        case .getLocationsWithFilter(let filter):
            guard let filter else { return nil }
            
            var queryItems: [String : String] = [:]
            if let page = filter.page { queryItems["page"] = "\(page)" }
            if let name = filter.name { queryItems["name"] = name }
            if let code = filter.type { queryItems["type"] = code }
            if let code = filter.dimension { queryItems["dimension"] = code }
            
            return queryItems
        }
    }
}
