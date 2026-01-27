import Foundation
import NetWork

// MARK: - Characters repository protocol

/// Интерфейс репозитория для получения персонажей из вселенной `"Rick and Morty"`.
public protocol CharactersRepository: Sendable {
    
    // MARK: Functions
    
    /// Выполняет `HTTP`-запрос на получение полной информации о персонаже по переданному идентификатору.
    /// - Parameter id: идентификатор персонажа о котором необходимо получить информацию.
    /// - Returns: структура с полной информацией о персонаже.
    /// - Throws: выбрасывает исключение типа `HTTPRequestError`, если процесс выполнения запроса завершился неудачно
    ///           (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getCharacter(with id: Int) async throws(HTTPRequestError) -> CharacterDTO
    /// Выполняет `HTTP`-запрос на получение полной информации о персонажах по переданному списку идентификаторов.
    /// - Parameter ids: список идентификаторов персонажей о которых необходимо получить информацию.
    /// - Returns: список структур с полной информацией о персонажах.
    /// - Throws: выбрасывает исключение типа `HTTPRequestError`, если процесс выполнения запроса завершился неудачно
    ///           (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getCharacters(with ids: [Int]) async throws(HTTPRequestError) -> [CharacterDTO]
    /// Выполняет `HTTP`-запрос на получение полной информации о персонажах с учетом фильтрации.
    /// - Parameter filter: структура с параметрами фильтрации персонажей.
    /// - Returns: список структур с полной информацией о персонажах.
    /// - Throws: выбрасывает исключение типа `HTTPRequestError`, если процесс выполнения запроса завершился неудачно
    ///           (отсутствие интернет-соединения, сервер вернул ошибку (4xx / 5xx) и т.д.).
    func getCharacters(with filter: CharactersHTTPRequestFilter?) async throws(HTTPRequestError) -> [CharacterDTO]
}
