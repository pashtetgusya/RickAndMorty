import Foundation

// MARK: - NS cache storage

/// Класс, реализующий хранилище на основе `NSCache`.
public final class NSCacheStorage {
    
    // MARK: Properties
    
    /// Кэш для хранения данных.
    private let cache: NSCache<NSString, NSData>
    /// Декодер для преобразования данных в значения.
    private let decoder: StorageDecoder
    /// Энкодер для преобразования значений в данные.
    private let encoder: StorageEncoder
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - decoder: декодер для преобразования данных в значения.
    ///   - encoder: энкодер для преобразования значений в данные.
    public init(
        decoder: StorageDecoder = JSONDecoder(),
        encoder: StorageEncoder = JSONEncoder()
    ) {
        self.cache = .init()
        self.decoder = decoder
        self.encoder = encoder
    }
}

// MARK: - Storage protocol implementation

extension NSCacheStorage: Storage {
    
    public func setValue<Value: Encodable & Sendable>(
        _ value: Value,
        for key: String
    ) throws(StorageError) {
        do {
            let data = try encoder.encode(value)
            cache.setObject(data as NSData, forKey: key as NSString)
        }
        catch { throw StorageError.typeToDataConverting(key: key) }
    }
    
    public func getValue<Value: Decodable & Sendable>(
        for key: String
    ) throws(StorageError) -> Value {
        guard
            let data = cache.object(forKey: key as NSString)
        else { throw StorageError.empty(key: key) }
        
        do { return try decoder.decode(Value.self, from: data as Data) }
        catch { throw StorageError.dataToTypeConverting(key: key) }
    }
    
    public func removeValue(for key: String) throws(StorageError) {
        cache.removeObject(forKey: key as NSString)
    }
    
    public func removeAllValues() throws(StorageError) {
        cache.removeAllObjects()
    }
}
