import Foundation
import ToolBox

// MARK: - Weak dependency storage

/// Класс, реализующий интерфейс хранилища зависимости,
/// время жизни которой равно времени жизни сильных ссылок на нее.
final class WeakStorage: DIStorage {
    
    // MARK: Properties
    
    private let _instance: Weak<AnyObject>
    var instance: Any? { _instance.wrappedValue }
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter instance: хранимая зависимость
    init(_ instance: Any?) {
        self._instance = Weak(wrappedValue: instance as? AnyObject)
    }
}
