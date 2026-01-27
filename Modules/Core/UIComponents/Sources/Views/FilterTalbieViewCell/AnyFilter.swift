import Foundation

// MARK: - Any filter

/// Структура для стирания (`type eraser`) протокола `Filter`.
public struct AnyFilter: Equatable, Hashable, Sendable {
    
    // MARK: Properties
    
    /// Стертый фильтр.
    private let filter: any Filter
    /// Идентификатор типа стертого фильтра.
    private let objectIdentifier: ObjectIdentifier
    
    /// Строковое значение (описание) фильтра.
    var rawValue: String { filter.rawValue }
    
    // MARK: Initialization
    
    /// Создат новый экземпляр структуры.
    /// - Parameter filter: фильтр, который нужно "стереть".
    init<F: Filter>(_ filter: F) {
        self.filter = filter
        self.objectIdentifier = .init(F.self)
    }
    
    // MARK: Type convertation functions
    
    /// Выполняет получение исходного типа фильтра до затирания.
    /// - Parameter type: тип получаемого фильтра.
    /// - Returns: фильтр.
    public func asFilter<T: Filter>(_ type: T.Type) -> T? {
        filter as? T
    }
    
    // MARK: Equatable protocol implementation
    
    public static func == (lhs: AnyFilter, rhs: AnyFilter) -> Bool {
        lhs.objectIdentifier == rhs.objectIdentifier &&
        lhs.rawValue == rhs.rawValue
    }
    
    // MARK: Hashable protocol implementation
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(objectIdentifier)
        hasher.combine(rawValue)
    }
}
