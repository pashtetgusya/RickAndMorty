import Foundation

// MARK: - Any parameter

/// Тип-стиратель (type eraser) для протокола `Parameter`.
struct AnyParameter: Equatable, Hashable, Sendable {
    
    // MARK: Properties
    
    /// Параметр, который "стирается".
    private let parameter: any Parameter
    /// Замыкание, реализующее сравнение параметров
    /// для соответствия протоколу `Equatable`.
    private let equals: @Sendable (AnyParameter) -> Bool
    /// Замыкание, реализующее вычисление хэша
    /// для соответствия протоколу `Hashable`.
    private let hash: @Sendable (inout Hasher) -> Void
    
    /// Иконка параметра.
    var icon: Data { parameter.icon }
    /// Название параметра.
    var name: String { parameter.name }
    /// Описание параметра.
    var description: String { parameter.description }
    
    // MARK: Initialization
    
    /// Создат новый экземпляр структуры.
    /// - Parameter filter: параметр, который нужно "стереть".
    init<T: Parameter>(_ parameter: T) {
        self.parameter = parameter
        self.equals = { otherParameter in
            guard
                let otherParameter = otherParameter.parameter as? T
            else { return false }
            
            return parameter == otherParameter
        }
        self.hash = { hasher in
            hasher.combine(parameter)
        }
    }
    
    // MARK: Equatable protocol implementation
    
    static func == (lhs: AnyParameter, rhs: AnyParameter) -> Bool {
        lhs.equals(rhs)
    }
    
    // MARK: Hashable protocol implementation
    
    func hash(into hasher: inout Hasher) {
        hash(&hasher)
    }
    
    // MARK: Functions
    
    /// Выполняет получение исходного тип параметра до затирания.
    /// - Parameter type: тип получаемого параметра.
    /// - Returns: фильтр.
    func nonErasedValue<T: Parameter>(as type: T.Type) -> T? {
        parameter as? T
    }
}
