import Foundation
import NetWork

// MARK: - Base episodes repository

/// Класс, реализующий интерфейс репозитория
/// для получения эпизодов из вселенной `"Rick and Morty"`.
public final class BaseEpisodesRepository {
    
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

// MARK: - Episodes repository protocol implementation

extension BaseEpisodesRepository: EpisodesRepository {
    
    public func getEpisode(
        with id: Int
    ) async throws(HTTPRequestError) -> EpisodeDTO {
        let endpoint = EpisodesHTTPRequestEndpoit.getEpisodeWitId(id)
        let episode: EpisodeDTO = try await httpClient.execute(with: endpoint)
        
        return episode
    }
    
    public func getEpisodes(
        with ids: [Int]
    ) async throws(HTTPRequestError) -> [EpisodeDTO] {
        let endpoint = EpisodesHTTPRequestEndpoit.getEpisodesWithIds(ids)
        let episodes: [EpisodeDTO] = try await httpClient.execute(with: endpoint)
        
        return episodes
    }
    
    public func getEpisodes(
        with filter: EpisodesHTTPRequestFilter?
    ) async throws(HTTPRequestError) -> [EpisodeDTO] {
        let endpoint = EpisodesHTTPRequestEndpoit.getEpisodesWithFilter(filter)
        let episodes: EpisodesDTO = try await httpClient.execute(with: endpoint)
        
        return episodes.list
    }
}
