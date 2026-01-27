import Foundation

// MARK: - Image repository protocol

/// Интерфейс репозитория для получения изображений.
public protocol ImageRepository: Sendable {
    
    // MARK: Functions
    
    /// Выполняет попытку получения изображения по указанному `URL`-адресу.
    ///
    /// В случае неудачи вернет `nil`.
    /// - Parameter url: `URL`-адрес для получения изображения.
    /// - Returns: данные полученного изображения.
    func image(for url: URL) async -> Data?
}
