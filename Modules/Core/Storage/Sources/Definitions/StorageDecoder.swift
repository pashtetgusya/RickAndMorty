import Foundation

// MARK: - Storage decoder protocol

/// Протокол, определяющий интерфейс для преобразования данных из хранилища в `Decodable`-типы.
public protocol StorageDecoder: Sendable {
    
    /// Выполняет преобразование данных в переданный `Decodable`-тип.
    /// - Parameters:
    ///   - type: тип, в который нужно преобразовать данные.
    ///   - data: данные для преобразования.
    /// - Returns: готовый объект переданного типа.
    /// - Throws: выбрасывает исключение, если процесс преобразования завершился неудачно.
    func decode<T: Decodable & Sendable>(_ type: T.Type, from data: Data) throws -> T
}
