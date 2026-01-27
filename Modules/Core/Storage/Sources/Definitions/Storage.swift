import Foundation

// MARK: - Storage protocol

/// Интерфейс для работы с хранилищем.
public protocol Storage: Sendable {
    
    // MARK: Functions
    
    /// Выполняет сохранение переданного значения по переданному ключу в хранилище.
    /// - Parameters:
    ///   - value: сохраняемое значение.
    ///   - key: уникальный ключ для сохранения значения.
    /// - Throws: выбрасывает исключение типа `StorageError`, если процесс сохранения значения завершился неудачно.
    func setValue<Value: Encodable & Sendable>(_ value: Value, for key: String) throws(StorageError)
    /// Выполняет получение сохраненного значения по переданному ключу из хранилища.
    /// - Parameter key: уникальный ключ для получения значения.
    /// - Returns: полученное значение из хранилища.
    /// - Throws: выбрасывает исключение типа `StorageError`, если процесс получения значения завершился неудачно.
    func getValue<Value: Decodable & Sendable>(for key: String) throws(StorageError) -> Value
    /// Выполняет удаление значения по переданному ключу из хранилища.
    /// - Parameter key: уникальный ключ для удаления значения.
    /// - Throws: выбрасывает исключение типа `StorageError`, если процесс удаления значения завершился неудачно.
    func removeValue(for key: String) throws(StorageError)
    /// Выполняет полную очистку хранилища.
    /// - Throws: выбрасывает исключение типа `StorageError`, если процесс очистки хранилища завершился неудачно.
    func removeAllValues() throws(StorageError)
}
