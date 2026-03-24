import Foundation

// MARK: - Filter protocol

/// Интерфейс фильтра.
public protocol Filter: Equatable, Hashable, Sendable {
    
    // MARK: Properties
    
    /// Значение фильтра.
    var rawValue: String { get }
    /// Идентификатор типа фильтра.
    var objectIdentifier: ObjectIdentifier { get }
}
