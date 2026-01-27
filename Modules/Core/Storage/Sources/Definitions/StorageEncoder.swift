import Foundation

// MARK: - Storage encoder protocol

/// Протокол, определяющий интерфейс для преобразования `Encodable`-типы в данные для хранилища.
public protocol StorageEncoder: Sendable {
    
    /// Выполняет преобразование переданного `Encodable`-типа в данные.
    /// - Parameter value: значение, которое нужно преобразовать в данные.
    /// - Returns: готовые данные.
    /// - Throws: выбрасывает исключение, если процесс преобразования завершился неудачно.
    func encode<T: Encodable & Sendable>(_ value: T) throws -> Data
}
