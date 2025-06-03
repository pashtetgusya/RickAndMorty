import Foundation

// MARK: - Image loader protocol

/// Интерфейс сервиса для загрузки изображений.
protocol ImageLoader: Sendable {
    
    // MARK: Functions
    
    /// Выполняет загрузку изображения по указанному URL-адресу.
    /// - Parameter url: URL-адрес для загрузки изображения.
    /// - Returns: данные изображения в формате `Data`.
    /// - Throws: `ImageLoadError` в случае возникновения ошибок (отсутствие интернет-соединения, получен пустой ответ и т.д.).
    func download(from url: URL) async throws (ImageLoadError) -> Data
}
