import Foundation

// MARK: - Reusable protocol

/// Протокол для стандартизации работы с повторно используемыми `view`-компонентами.
///
/// Позволяет унифицировать процесс регистрации и повторного использования ячеек таблиц,
/// коллекций и других `view`-компонентов.
public protocol Reusable {
    
    /// Уникальный идентификатор для повторного использования объекта.
    ///
    /// По умолчанию возвращает имя типа.
    static var reuseIdentifier: String { get }
}

// MARK: - Reusable protocol base implementation

public extension Reusable {
    
    static var reuseIdentifier: String { String(describing: self) }
}
