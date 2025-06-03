import Foundation

// MARK: - Image cache protocol

/// Интерфейс сервиса для кэширования изображений.
protocol ImageCache: Sendable {
    
    // MARK: Functions
    
    /// Сохраняет изображение в кэш.
    /// - Parameters:
    ///   - imageData: данные изображения для кэширования.
    ///   - key: уникальный ключ для доступа к изображению.
    func store(_ imageData: Data, for key: NSString) async
    /// Возвращает закэшированное изображение по переданному ключу.
    /// - Parameter key: ключ, по которому было сохранено изображение.
    /// - Returns: данные изображения или `nil`, если изображение не найдено в кэше.
    func image(for key: NSString) async -> Data?
    /// Удаляет изображение из кэша.
    /// - Parameter key: ключ, по которому было сохранено изображение.
    func remove(for key: NSString) async
}
