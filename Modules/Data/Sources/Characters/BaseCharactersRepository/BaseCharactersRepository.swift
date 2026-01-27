import Foundation
import NetWork

// MARK: - Base characters repository

/// Класс, реализующий интерфейс репозитория
/// для получения персонажей из вселенной `"Rick and Morty"`.
public final class BaseCharactersRepository {
    
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

// MARK: - Characters repository protocol implementation

extension BaseCharactersRepository: CharactersRepository {
    
    public func getCharacter(
        with id: Int
    ) async throws(HTTPRequestError) -> CharacterDTO {
        let endpoint = CharactersHTTPRequestEndpoint.getCharacterWitId(id)
        let character: CharacterDTO = try await httpClient.execute(with: endpoint)
        
        return character
    }
    
    public func getCharacters(
        with ids: [Int]
    ) async throws(HTTPRequestError) -> [CharacterDTO] {
        let endpoint = CharactersHTTPRequestEndpoint.getCharactersWithIds(ids)
        let characters: [CharacterDTO] = try await httpClient.execute(with: endpoint)
        
        return characters
    }
    
    public func getCharacters(
        with filter: CharactersHTTPRequestFilter?
    ) async throws(HTTPRequestError) -> [CharacterDTO] {
        let endpoint = CharactersHTTPRequestEndpoint.getCharactersWithFilter(filter)
        let characters: CharactersDTO = try await httpClient.execute(with: endpoint)
        
        return characters.list
    }

}
