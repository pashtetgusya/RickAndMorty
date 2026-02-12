import Foundation

// MARK: - Weak property wrapper

/// Класс, реализующий обертку для создания слабых ссылок на объекты.
@propertyWrapper
public final class Weak<T: AnyObject> {
    
    // MARK: Properties
    
    ///Слабая ссылка на обернутое значение.
    private weak var value: T?
    
    /// Обернутое значение.
    public var wrappedValue: T? {
        get { value }
        set { value = newValue }
    }
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter value: оборачиваемое значение.
    public init(wrappedValue value: T?) {
        self.value = value
    }
}
