import Foundation

// MARK: - Rick and Morty episode HTTP request endpoint

/// Перечень endpoint'ов для HTTP-запросов в
/// API эпизодов из вселенной `"Rick and Morty"`.
enum RnMEpisodeHTTPRequestEndpoit: HTTPRequestEndpoint {
    
    // MARK: Cases
    
    /// Endpoint получения полной информации об эпизоде по переданному идентификатору.
    /// - Parameter id: уникальный идентификатор эпизода.
    /// - Returns: endpoint для запроса вида `/api/episode/{id}`.
    case getEpisodeWitId(_ id: Int)
    /// Endpoint получения полной информации об эпизодах по переданному списку идентификаторов.
    /// - Parameter ids: список идентификаторов эпизодов.
    /// - Returns: endpoint для запроса вида `/api/episode/[id1,id2,...]`.
    case getEpisodesWithIds(_ ids: [Int])
    /// Endpoint получения полной информации об эпизодах.
    /// - Parameter filter: параметры фильтрации.
    /// - Returns: Endpoint для запроса вида `/api/episode` с query-параметрами.
    case getEpisodesWithFilter(_ filter: RnMEpisodeHTTPRequestFilter?)
    
    // MARK: Properties
    
    var method: HTTPRequestMethod { .get }
    
    var scheme: HTTPRequestScheme { .https }
    var host: String { RnMHTTPRequestConstants.host }
    var path: String {
        switch self {
        case .getEpisodeWitId(let id): "/api/episode/\(id)"
        case .getEpisodesWithIds(let ids): "/api/episode/\(ids)"
        case .getEpisodesWithFilter: "/api/episode"
        }
    }
    
    var headers: [String : String]? { nil }
    var queryItems: [String : String]? {
        switch self {
        case .getEpisodeWitId: return nil
        case .getEpisodesWithIds: return nil
        case .getEpisodesWithFilter(let filter):
            guard let filter else { return nil }
            
            var queryItems: [String : String] = [:]
            if let page = filter.page { queryItems["page"] = "\(page)" }
            if let name = filter.name { queryItems["name"] = name }
            if let code = filter.code { queryItems["episode"] = code }
            
            return queryItems
        }
    }
}
