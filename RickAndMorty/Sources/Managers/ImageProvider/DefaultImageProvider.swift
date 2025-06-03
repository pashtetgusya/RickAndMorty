import Foundation

// MARK: - Default image provider

/// Класс, реализующий интерфейс для получения изображений.
final class DefaultImageProvider: ImageProvider {
    
    // MARK: Properties
    
    let imageLoader: ImageLoader
    let imageCache: ImageCache
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - imageLoader: сервис загрузки изображений из сети.
    ///   - imageCache: кэш для хранения загруженных изображений.
    init(
        imageLoader: ImageLoader,
        imageCache: ImageCache
    ) {
        self.imageLoader = imageLoader
        self.imageCache = imageCache
    }
    
    // MARK: Functions
    
    func image(for url: URL) async -> Data? {
        let imageKey = url.absoluteString as NSString
        
        if let image = await imageCache.image(for: imageKey) {
            return image
        }
        
        do {
            let image = try await imageLoader.download(from: url)
            await imageCache.store(image, for: imageKey)
            
            return image
        }
        catch { return nil }
    }
}
