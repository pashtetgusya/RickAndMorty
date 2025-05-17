import Foundation

// MARK: - Rick and Morty episode HTTP client protocol

/// Интерфейс HTTP-клиента для работы с API эпизодов из вселенной `"Rick and Morty"`.
protocol RnMEpisodeHTTPClient: HTTPClient {
    
    // MARK: Functions
    
    /// Выполняет HTTP-запрос на получение полной информации об эпизоде по переданному идентификатору.
    /// - Parameter id: идентификатор эпизода о котором необходимо получить информацию.
    /// - Returns: структура с полной информацией об эпизоде.
    /// - Throws: `HTTPRequestError` в случае возникновения ошибок (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getEpisode(with id: Int) async throws (HTTPRequestError) -> RnMEpisodeDTO
    /// Выполняет HTTP-запрос на получение полной информации об эпизодах по переданному списку идентификаторов.
    /// - Parameter ids: список идентификаторов эпизодов о которых необходимо получить информацию.
    /// - Returns: список структур с полной информацией об эпизодах.
    /// - Throws: `HTTPRequestError` в случае возникновения ошибок (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getEpisodes(with ids: [Int]) async throws (HTTPRequestError) -> [RnMEpisodeDTO]
    /// Выполняет HTTP-запрос на получение полной информации об эпизодах с возможностью фильтрации.
    /// - Parameter filter: структура с параметрами фильтрации эпизодов.
    /// - Returns: список структур с полной информацией об эпизодах.
    /// - Throws: `HTTPRequestError` в случае возникновения ошибок (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getEpisodes(with filter: RnMEpisodeHTTPRequestFilter?) async throws (HTTPRequestError) -> [RnMEpisodeDTO]
}
