import Foundation

// MARK: - Image loader protocol

/// Интерфейс сервиса загрузки изображений.
public protocol ImageLoader: Sendable {
    
    // MARK: Functions
    
    /// Выполняет загрузку изображения по указанному `URL`-адресу.
    /// - Parameter url: `URL`-адрес для загрузки изображения.
    /// - Returns: данные изображения в формате `Data`.
    /// - Throws: выбрасывает исключение типа `ImageLoadError`, если процесс загрузки изображения завершился неудачно
    ///           (отсутствие интернет-соединения, пустой ответ и т.д.).
    func download(from url: URL) async throws(ImageLoadError) -> Data
    /// Выполняет отмену загрузки изображения по указанному `URL`-адресу.
    /// - Parameter url: `URL`-адрес для загрузки изображения.
    func cancelDownload(from url: URL) async
    /// Выполняет отмену загрузки всех изображений.
    func cancelAllDownloads() async
}
