import Foundation

// MARK: - Any filter

/// Тип-стиратель (type eraser) для протокола `Filter`.
struct AnyFilter: Equatable, Hashable, Sendable {
    
    // MARK: Properties
    
    /// Фильтр, который "стирается".
    private let filter: any Filter
    /// Замыкание, реализующее сравнение фильтров
    /// для  соответствия протоколу `Equatable`.
    private let equals: @Sendable (AnyFilter) -> Bool
    /// Замыкание, реализующее вычисление хэша
    /// для  соответствия протоколу `Hashable`.
    private let hash: @Sendable (inout Hasher) -> Void
    
    /// Строковое значение (описание) фильтра.
    var rawValue: String { filter.rawValue }
    
    // MARK: Initialization
    
    /// Создат новый экземпляр структуры.
    /// - Parameter filter: фильтр, который нужно "стереть".
    init<F: Filter>(_ filter: F) {
        self.filter = filter
        self.equals = { otherFilter in
            guard
                let otherFilter = otherFilter.filter as? F
            else { return false }
            
            return filter == otherFilter
        }
        self.hash = { hasher in
            hasher.combine(filter)
        }
    }
    
    // MARK: Equatable protocol implementation
    
    static func == (lhs: AnyFilter, rhs: AnyFilter) -> Bool {
        lhs.equals(rhs)
    }
    
    // MARK: Hashable protocol implementation
    
    func hash(into hasher: inout Hasher) {
        hash(&hasher)
    }
    
    // MARK: Functions
    
    /// Получает исходный тип фильтра до затирания.
    /// - Parameter type: тип получаемого фильтра.
    /// - Returns: фильтр.
    func nonErasedValue<T: Filter>(as type: T.Type) -> T? {
        filter as? T
    }
}
