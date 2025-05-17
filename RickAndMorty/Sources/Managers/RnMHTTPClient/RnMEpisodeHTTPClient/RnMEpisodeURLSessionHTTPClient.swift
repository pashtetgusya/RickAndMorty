import Foundation

// MARK: - Rick and Morty episode URL session HTTP client

/// Класс, реализующий интерфейс HTTP-клиента
/// для работы с API эпизодов из вселенной `"Rick and Morty"` на основе `URLSession`.
final class RnMEpisodeURLSessionHTTPClient: RnMURLSessionHTTPClient, RnMEpisodeHTTPClient {
    
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
    
    func getEpisode(with id: Int) async throws(HTTPRequestError) -> RnMEpisodeDTO {
        let endpoint = RnMEpisodeHTTPRequestEndpoit.getEpisodeWitId(id)
        let episode: RnMEpisodeDTO = try await execute(with: endpoint)
        
        return episode
    }
    
    func getEpisodes(with ids: [Int]) async throws(HTTPRequestError) -> [RnMEpisodeDTO] {
        let endpoint = RnMEpisodeHTTPRequestEndpoit.getEpisodesWithIds(ids)
        let episodes: [RnMEpisodeDTO] = try await execute(with: endpoint)
        
        return episodes
    }
    
    func getEpisodes(with filter: RnMEpisodeHTTPRequestFilter?) async throws(HTTPRequestError) -> [RnMEpisodeDTO] {
        let endpoint = RnMEpisodeHTTPRequestEndpoit.getEpisodesWithFilter(filter)
        let episodes: RnMEpisodesDTO = try await execute(with: endpoint)
        
        return episodes.list
    }
}
