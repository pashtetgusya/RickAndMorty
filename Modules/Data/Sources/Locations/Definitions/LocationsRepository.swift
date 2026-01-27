import Foundation
import NetWork

// MARK: - Locations repository protocol

/// Интерфейс репозитория для получения локаций из вселенной `"Rick and Morty"`.
public protocol LocationsRepository {
    
    // MARK: Functions
    
    /// Выполняет `HTTP`-запрос на получение полной информации о локации по переданному идентификатору.
    /// - Parameter id: идентификатор локации о которой необходимо получить информацию.
    /// - Returns: структура с полной информацией о локации.
    /// - Throws: выбрасывает исключение типа `HTTPRequestError`, если процесс выполнения запроса завершился неудачно
    ///           (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getLocation(with id: Int) async throws(HTTPRequestError) -> LocationDTO
    /// Выполняет `HTTP`-запрос на получение полной информации о локациях по переданному списку идентификаторов.
    /// - Parameter ids: список идентификаторов локаций о которых необходимо получить информацию.
    /// - Returns: список структур с полной информацией о локациях.
    /// - Throws: выбрасывает исключение типа `HTTPRequestError`, если процесс выполнения запроса завершился неудачно
    ///           (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getLocations(with ids: [Int]) async throws(HTTPRequestError) -> [LocationDTO]
    /// Выполняет `HTTP`-запрос на получение полной информации о локациях с учетом фильтрации.
    /// - Parameter filter: структура с параметрами фильтрации локаций.
    /// - Returns: список структур с полной информацией о локациях.
    /// - Throws: выбрасывает исключение типа `HTTPRequestError`, если процесс выполнения запроса завершился неудачно
    ///           (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getLocations(with filter: LocationsHTTPRequestFilter?) async throws(HTTPRequestError) -> [LocationDTO]
}
