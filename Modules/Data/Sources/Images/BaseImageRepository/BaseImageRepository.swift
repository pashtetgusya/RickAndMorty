import Foundation
import NetWork
import Storage

// MARK: - Base image repository

/// Актор, реализующий интерфейс репозитория для получения изображений.
public actor BaseImageRepository {
    
    // MARK: Properties
    
    /// Сервис для загрузки изображений из сети.
    private let loader: ImageLoader
    /// Хранилище для кэширования загруженных изображений.
    private let storage: Storage
    
    // MARK: Initializatiom
    
    /// Создает новый экземпляр актора.
    /// - Parameters:
    ///   - loader: сервис для загрузки изображений из сети.
    ///   - storage: хранилище для кэширования загруженных изображений.
    public init(
        loader: ImageLoader,
        storage: Storage
    ) {
        self.loader = loader
        self.storage = storage
    }
}

// MARK: - Image repository protocol implementation

extension BaseImageRepository: ImageRepository {
    
    public func image(for url: URL) async -> Data? {
        if let image = getImageFromStorage(for: url.absoluteString) { return image }
        else if let image = await getImageFromNetwork(for: url) { return image }
        else { return nil }
    }
}

// MARK: - Support functions

private extension BaseImageRepository {
    
    /// Выполняет попытку получения изображения по переданному ключу из хранилища.
    /// - Parameter key: уникальный ключ для получения изображения.
    /// - Returns: полученное изображение из хранилища.
    func getImageFromStorage(for key: String) -> Data? {
        do {
            let image: Data = try storage.getValue(for: key)
            
            return image
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Выполняет попытку загрузки изображения по указанному `URL`-адресу.
    /// - Parameter url: `URL`-адрес для загрузки изображения.
    /// - Returns: данные изображения в формате `Data`.
    func getImageFromNetwork(for url: URL) async -> Data? {
        do {
            let image: Data = try await loader.download(from: url)
            try storage.setValue(image, for: url.absoluteString)
            
            return image
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
