import Foundation

// MARK: - Filter protocol

/// Интерфейс фильтра.
public protocol Filter: Equatable, Hashable, Sendable {
    
    // MARK: Properties
    
    /// Значение фильтра.
    var rawValue: String { get }
}

// MARK: - Filter protocol base implementation

public extension Filter {
    
    /// Значение текущего фильтра со стертым типом.
    var erased: AnyFilter {
        AnyFilter(self)
    }
}
