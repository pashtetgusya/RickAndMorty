import Foundation

// MARK: - Atomic property wrapper

/// Класс, реализующий потоко безопасную обертку для значений любого типа.
///
/// Гарантирует атомарный доступ к значению из разных потоков путем
/// использования `NSRecursiveLock` для синхронизации.
@propertyWrapper
public final class Atomic<Value>: @unchecked Sendable {
    
    // MARK: Properties
    
    /// Блокировщик для обеспечения синхронизации
    /// при взаимодествии с обернутым значением.
    private let lock: NSRecursiveLock = NSRecursiveLock()
    ///Обернутое значение.
    private var value: Value
    
    /// Обернутое значение.
    ///
    /// Предоставляет потокобезопасный доступ к обернутому значению.
    public var wrappedValue: Value {
        get {
            defer { lock.unlock() }
            lock.lock()
            
            return value
        }
        set {
            defer { lock.unlock() }
            lock.lock()
            
            value = newValue
        }
    }
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter value: оборачиваемое значение.
    public init(wrappedValue value: Value) {
        self.value = value
    }
}
