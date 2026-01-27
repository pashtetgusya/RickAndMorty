import Foundation

// MARK: - Parameter protocol

/// Интерфейс параметра.
public protocol Parameter: Equatable, Hashable, Sendable {
    
    // MARK: Properties
    
    /// Иконка параметра.
    var icon: Data { get }
    /// Название параметра.
    var name: String { get }
    /// Описание параметра.
    var description: String { get }
}

// MARK: - Parameter protocol base implementation

public extension Parameter {
    
    /// Значение текущего параметра со стертым типом.
    var erased: AnyParameter {
        AnyParameter(self)
    }
}
