import Foundation

// MARK: - Rick and Morty location HTTP client protocol

/// Интерфейс HTTP-клиента для работы с API локаций из вселенной `"Rick and Morty"`.
protocol RnMLocationHTTPClient: HTTPClient {
    
    // MARK: Functions
    
    /// Выполняет HTTP-запрос на получение полной информации о локации по переданному идентификатору.
    /// - Parameter id: идентификатор локации о которой необходимо получить информацию.
    /// - Returns: структура с полной информацией о локации.
    /// - Throws: `HTTPRequestError` в случае возникновения ошибок (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getLocation(with id: Int) async throws (HTTPRequestError) -> RnMLocationDTO
    /// Выполняет HTTP-запрос на получение полной информации о локациях по переданному списку идентификаторов.
    /// - Parameter ids: список идентификаторов локаций о которых необходимо получить информацию.
    /// - Returns: список структур с полной информацией о локациях.
    /// - Throws: `HTTPRequestError` в случае возникновения ошибок (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getLocations(with ids: [Int]) async throws (HTTPRequestError) -> [RnMLocationDTO]
    /// Выполняет HTTP-запрос на получение полной информации о локациях с возможностью фильтрации.
    /// - Parameter filter: структура с параметрами фильтрации локаций.
    /// - Returns: список структур с полной информацией о локациях.
    /// - Throws: `HTTPRequestError` в случае возникновения ошибок (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getLocations(with filter: RnMLocationHTTPRequestFilter?) async throws (HTTPRequestError) -> [RnMLocationDTO]
}
