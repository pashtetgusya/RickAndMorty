import Foundation

// MARK: - Storage error

/// Перечень ошибок при работе с хранилищем.
public enum StorageError: LocalizedError {
    
    // MARK: Cases
    
    /// Не удалось получить объект из хранилища.
    case empty(key: String)
    /// Не удалось выполнить преобразование из `Type` в `Data`.
    case typeToDataConverting(key: String)
    /// Не удалось выполнить преобразование из `Data` в `Type`.
    case dataToTypeConverting(key: String)
    /// Произошла неизвестная ошибка.
    case unknown(key: String, description: String)
    
    // MARK: Properties
    
    public var errorDescription: String? {
        switch self {
        case .empty(let key):
            "Не удалось получить объект из хранилища по переданному ключу: \(key)."
        case .typeToDataConverting(let key):
            "Не удалось выполнить преобразование из `Type` в `Data` для объекта по переданному ключу: \(key)."
        case .dataToTypeConverting(let key):
            "Не удалось выполнить преобразование из `Data` в `Type` для объекта по переданному ключу: \(key)."
        case .unknown(let key, let description):
            "Произошла неизвестная ошибка при выполнении операции с объектом по переданному ключу: \(key). \(description)"
        }
    }
}
