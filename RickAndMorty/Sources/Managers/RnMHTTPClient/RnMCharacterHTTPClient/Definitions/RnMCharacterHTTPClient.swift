import Foundation

// MARK: - Rick and Morty character HTTP client protocol

/// Интерфейс HTTP-клиента для работы с API персонажей из вселенной `"Rick and Morty"`.
protocol RnMCharacterHTTPClient: HTTPClient {
    
    // MARK: Functions
    
    /// Выполняет HTTP-запрос на получение полной информации о персонаже по переданному идентификатору.
    /// - Parameter id: идентификатор персонажа о котором необходимо получить информацию.
    /// - Returns: структура с полной информацией о персонаже.
    /// - Throws: `HTTPRequestError` в случае возникновения ошибок (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getCharacter(with id: Int) async throws (HTTPRequestError) -> RnMCharacterDTO
    /// Выполняет HTTP-запрос на получение полной информации о персонажах по переданному списку идентификаторов.
    /// - Parameter ids: список идентификаторов персонажей о которых необходимо получить информацию.
    /// - Returns: список структур с полной информацией о персонажах.
    /// - Throws: `HTTPRequestError` в случае возникновения ошибок (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getCharacters(with ids: [Int]) async throws (HTTPRequestError) -> [RnMCharacterDTO]
    /// Выполняет HTTP-запрос на получение полной информации о персонажах с возможностью фильтрации.
    /// - Parameter filter: структура с параметрами фильтрации персонажей.
    /// - Returns: список структур с полной информацией о персонажах.
    /// - Throws: `HTTPRequestError` в случае возникновения ошибок (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getCharacters(with filter: RnMCharacterHTTPRequestFilter?) async throws (HTTPRequestError) -> [RnMCharacterDTO]
}
