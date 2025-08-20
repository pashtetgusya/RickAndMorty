import Foundation

// MARK: - Parameter protocol

/// Интерфейс параметра (персонажа / эпизода / локации).
protocol Parameter: Equatable, Hashable, Sendable {
    
    // MARK: Properties
    
    /// Иконка параметра.
    var icon: Data { get }
    /// Название параметра.
    var name: String { get }
    /// Описание параметра.
    var description: String { get }
}

// MARK: - Parameter protocol base implementation

extension Parameter {
    
    /// Выполняет стирание типа для текущего параметра.
    func erased() -> AnyParameter {
        AnyParameter(self)
    }
}
