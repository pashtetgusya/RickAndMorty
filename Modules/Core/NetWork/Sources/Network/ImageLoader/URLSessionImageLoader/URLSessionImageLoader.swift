import Foundation

// MARK: - URL session image loader

/// Актор, реализующий интерфейс сервиса загрузки изображений на основе `URLSession`.
public actor URLSessionImageLoader {
    
    // MARK: Properties
    
    /// Сессия для выполнения сетевых запросов.
    private let session: URLSession
    /// Список задач на загрузку изображений.
    private var imageLoadTaskList: [String: Task<Data, Error>]
    
    // MARK: Initialization
    
    /// Создает новый экземпляр актора.
    /// - Parameter session: сессия, используемая для выполнения сетевых запросов.
    public init(session: URLSession = URLSession.shared) {
        self.session = session
        self.imageLoadTaskList = [:]
    }
}

// MARK: - Image loader protocol implementation

extension URLSessionImageLoader: ImageLoader {
    
    public func download(from url: URL) async throws(ImageLoadError) -> Data {
        let taskKey = url.absoluteString
        let imageLoadTask: Task<Data, Error>
        
        if let task = imageLoadTaskList[taskKey] {
            imageLoadTask = task
        }
        else {
            let task = Task { [weak self] in
                do {
                    guard
                        let (data, response) = try await self?.session.data(from: url),
                        let response = response as? HTTPURLResponse
                    else { throw ImageLoadError.emptyResponse }
                    
                    switch response.statusCode {
                    case 200...299: return data
                    
                    default: throw ImageLoadError.invalidStatusCode(response.statusCode)
                    }
                }
                catch URLError.notConnectedToInternet,
                      URLError.networkConnectionLost { throw ImageLoadError.networkDown }
                catch { throw error }
            }
            
            imageLoadTask = task
            imageLoadTaskList[taskKey] = imageLoadTask
        }
        
        defer { imageLoadTaskList.removeValue(forKey: taskKey) }
        
        do { return try await imageLoadTask.value }
        catch let error as ImageLoadError { throw error }
        catch { throw ImageLoadError.unknown(error.localizedDescription) }
    }
    
    public func cancelDownload(from url: URL) async {
        let taskKey = url.absoluteString
        imageLoadTaskList[taskKey]?.cancel()
        imageLoadTaskList.removeValue(forKey: taskKey)
    }
    
    public func cancelAllDownloads() async {
        imageLoadTaskList.values.forEach { $0.cancel() }
        imageLoadTaskList.removeAll()
    }
}
