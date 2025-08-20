import Foundation

// MARK: - Filter protocol

/// Интерфейс фильтра.
protocol Filter: Equatable, Hashable, Sendable {
    
    // MARK: Properties
    
    /// Строковое значение (описание) фильтра.
    var rawValue: String { get }
}

// MARK: - Filter protocol base implementation

extension Filter {
    
    /// Выполняет стирание типа для текущего фильтра.
    func erased() -> AnyFilter {
        AnyFilter(self)
    }
}
