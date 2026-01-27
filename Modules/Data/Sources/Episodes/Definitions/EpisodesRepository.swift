import Foundation
import NetWork

// MARK: - Episodes repository protocol

/// Интерфейс репозитория для получения эпизодов из вселенной `"Rick and Morty"`.
public protocol EpisodesRepository: Sendable {
    
    // MARK: Functions
    
    /// Выполняет `HTTP`-запрос на получение полной информации об эпизоде по переданному идентификатору.
    /// - Parameter id: идентификатор эпизода о котором необходимо получить информацию.
    /// - Returns: структура с полной информацией об эпизоде.
    /// - Throws: выбрасывает исключение типа `HTTPRequestError`, если процесс выполнения запроса завершился неудачно
    ///           (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getEpisode(with id: Int) async throws(HTTPRequestError) -> EpisodeDTO
    /// Выполняет `HTTP`-запрос на получение полной информации об эпизодах по переданному списку идентификаторов.
    /// - Parameter ids: список идентификаторов эпизодов о которых необходимо получить информацию.
    /// - Returns: список структур с полной информацией об эпизодах.
    /// - Throws: выбрасывает исключение типа `HTTPRequestError`, если процесс выполнения запроса завершился неудачно
    ///           (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getEpisodes(with ids: [Int]) async throws(HTTPRequestError) -> [EpisodeDTO]
    /// Выполняет `HTTP`-запрос на получение полной информации об эпизодах с учетом фильтрации.
    /// - Parameter filter: структура с параметрами фильтрации эпизодов.
    /// - Returns: список структур с полной информацией об эпизодах.
    /// - Throws: выбрасывает исключение типа `HTTPRequestError`, если процесс выполнения запроса завершился неудачно
    ///           (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getEpisodes(with filter: EpisodesHTTPRequestFilter?) async throws(HTTPRequestError) -> [EpisodeDTO]
}
