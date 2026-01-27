import Foundation

// MARK: - Any parameter

/// Структура для стирания (`type eraser`) протокола `Parameter`.
public struct AnyParameter: Equatable, Hashable, Sendable {
    
    // MARK: Properties
    
    /// Стертый параметр.
    private let parameter: any Parameter
    /// Идентификатор типа стертого параметра.
    private let objectIdentifier: ObjectIdentifier
    
    /// Иконка параметра.
    var icon: Data { parameter.icon }
    /// Название параметра.
    var name: String { parameter.name }
    /// Описание параметра.
    var description: String { parameter.description }
    
    // MARK: Initialization
    
    /// Создат новый экземпляр структуры.
    /// - Parameter parameter: параметр, который нужно "стереть".
    init<T: Parameter>(_ parameter: T) {
        self.parameter = parameter
        self.objectIdentifier = .init(T.self)
    }
    
    // MARK: Type convertation function
    
    /// Выполняет получение исходного тип параметра до затирания.
    /// - Parameter type: тип получаемого параметра.
    /// - Returns: фильтр.
    func asParameter<T: Parameter>(_ type: T.Type) -> T? {
        parameter as? T
    }
    
    // MARK: Equatable protocol implementation
    
    public static func == (lhs: AnyParameter, rhs: AnyParameter) -> Bool {
        lhs.objectIdentifier == rhs.objectIdentifier &&
        lhs.icon == rhs.icon &&
        lhs.name == rhs.name &&
        lhs.description == rhs.description
    }
    
    // MARK: Hashable protocol implementation
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(objectIdentifier)
        hasher.combine(icon)
        hasher.combine(name)
        hasher.combine(description)
    }
}
