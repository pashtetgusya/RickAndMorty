import Foundation

// MARK: - Rick and Morty character HTTP request endpoint

/// Перечень endpoint'ов для HTTP-запросов в
/// API персонажей из вселенной `"Rick and Morty"`.
enum RnMCharacterHTTPRequestEndpoint: HTTPRequestEndpoint {
    
    // MARK: Cases
    
    /// Endpoint получения полной информации о персонаже по переданному идентификатору.
    /// - Parameter id: уникальный идентификатор персонажа.
    /// - Returns: endpoint для запроса вида `/api/character/{id}`.
    case getCharacterWitId(_ id: Int)
    /// Endpoint получения полной информации о персонажах по переданному списку идентификаторов.
    /// - Parameter ids: список идентификаторов персонажей.
    /// - Returns: endpoint для запроса вида `/api/character/[id1,id2,...]`.
    case getCharactersWithIds(_ ids: [Int])
    /// Endpoint получения полной информации о персонажах.
    /// - Parameter filter: параметры фильтрации.
    /// - Returns: Endpoint для запроса вида `/api/character` с query-параметрами.
    case getCharactersWithFilter(_ filter: RnMCharacterHTTPRequestFilter?)
    
    // MARK: Properties
    
    var method: HTTPRequestMethod { .get }
    
    var scheme: HTTPRequestScheme { .https }
    var host: String { RnMHTTPRequestConstants.host }
    var path: String {
        switch self {
        case .getCharacterWitId(let id): "/api/character/\(id)"
        case .getCharactersWithIds(let ids): "/api/character/\(ids)"
        case .getCharactersWithFilter: "/api/character"
        }
    }
    
    var headers: [String : String]? { nil }
    var queryItems: [String : String]? {
        switch self {
        case .getCharacterWitId: return nil
        case .getCharactersWithIds: return nil
        case .getCharactersWithFilter(let filter):
            guard let filter else { return nil }
            
            var queryItems: [String : String] = [:]
            if let page = filter.page { queryItems["page"] = "\(page)" }
            if let name = filter.name { queryItems["name"] = name }
            if let status = filter.status { queryItems["status"] = status.rawValue }
            if let species = filter.species { queryItems["species"] = species }
            if let type = filter.type { queryItems["type"] = type }
            if let gender = filter.gender { queryItems["gender"] = gender.rawValue }
            
            return queryItems
        }
    }
}
