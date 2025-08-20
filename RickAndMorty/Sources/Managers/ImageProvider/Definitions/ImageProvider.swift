import Foundation

// MARK: - Image provider protocol

/// Интерфейс для получения изображений.
protocol ImageProvider: Sendable {
    
    // MARK: Properties
    
    /// Сервис загрузки изображений из сети.
    var imageLoader: ImageLoader { get }
    /// Кэш для хранения загруженных изображений.
    var imageCache: ImageCache { get }
    
    // MARK: Functions
    
    /// Выполняет получение изображения по указанному`URL`-адресу.
    /// - Parameter url: `URL`-адрес изображения для получения.
    /// - Returns: данные изображения в формате `Data`.
    func image(for url: URL) async -> Data?
}
