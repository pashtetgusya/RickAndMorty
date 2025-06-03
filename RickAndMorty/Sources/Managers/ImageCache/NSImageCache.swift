import Foundation

// MARK: - NS Image cache

/// Класс, реализующий интерфейс сервиса для кэширования изображений на основе `NSCache`.
final class NSImageCache: ImageCache {
    
    // MARK: Properties
    
    /// Кэш для хранения изображений.
    private let cache: NSCache<NSString, NSData>
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init() {
        self.cache = NSCache()
    }
    
    // MARK: Functions
    
    func store(_ imageData: Data, for key: NSString) async {
        cache.setObject(imageData as NSData, forKey: key)
    }
    
    func image(for key: NSString) async -> Data? {
        cache.object(forKey: key) as? Data
    }
    
    func remove(for key: NSString) async {
        cache.removeObject(forKey: key)
    }
}
