import Foundation

// MARK: - Rick and Morty character URL session HTTP client

/// Класс, реализующий интерфейс HTTP-клиента
/// для работы с API персонажей из вселенной `"Rick and Morty"`  на основе `URLSession`..
final class RnMCharacterURLSessionHTTPClient: RnMURLSessionHTTPClient, RnMCharacterHTTPClient {
    
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
    
    func getCharacter(with id: Int) async throws(HTTPRequestError) -> RnMCharacterDTO {
        let endpoint = RnMCharacterHTTPRequestEndpoint.getCharacterWitId(id)
        let character: RnMCharacterDTO = try await execute(with: endpoint)
        
        return character
    }
    
    func getCharacters(with ids: [Int]) async throws(HTTPRequestError) -> [RnMCharacterDTO] {
        let endpoint = RnMCharacterHTTPRequestEndpoint.getCharactersWithIds(ids)
        let characters: [RnMCharacterDTO] = try await execute(with: endpoint)
        
        return characters
    }
    
    func getCharacters(with filter: RnMCharacterHTTPRequestFilter?) async throws(HTTPRequestError) -> [RnMCharacterDTO] {
        let endpoint = RnMCharacterHTTPRequestEndpoint.getCharactersWithFilter(filter)
        let characters: RnMCharactersDTO = try await execute(with: endpoint)
        
        return characters.list
    }
}
