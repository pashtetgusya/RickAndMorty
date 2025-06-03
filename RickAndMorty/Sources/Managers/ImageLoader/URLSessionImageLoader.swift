import Foundation

// MARK: - URL session image loader

/// Актор, реализующий интерфейс сервиса для загрузки изображений на основе `URLSession`.
final actor URLSessionImageLoader: ImageLoader {
    
    // MARK: Properties
    
    /// Сессия для выполнения сетевых запросов.
    private let session: URLSession
    /// Список задач на загрузку изображений.
    private var imageLoadTaskList: [String: Task<Data, Error>] = [:]
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter session: сессия, используемая для выполнения сетевых запросов.
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: Functions
    
    func download(from url: URL) async throws(ImageLoadError) -> Data {
        if let imageLoadTask = imageLoadTaskList[url.absoluteString] {
            do { return try await imageLoadTask.value }
            catch let error as ImageLoadError { throw error }
            catch { throw .unknown(error.localizedDescription) }
        }
        else {
            let imageLoadTask = Task {
                do {
                    let (data, response) = try await session.data(from: url)
                    
                    guard
                        let response = response as? HTTPURLResponse
                    else { throw ImageLoadError.emptyResponse }
                    
                    switch response.statusCode {
                    case 200...299: return data
                    
                    default: throw ImageLoadError.invalidStatusCode(response.statusCode)
                    }
                }
                catch let error as ImageLoadError { throw error }
                catch URLError.notConnectedToInternet { throw ImageLoadError.networkDown }
                catch { throw error }
            }
            imageLoadTaskList[url.absoluteString] = imageLoadTask
            
            do { return try await imageLoadTask.value }
            catch let error as ImageLoadError { throw error }
            catch { throw .unknown(error.localizedDescription) }
        }
    }
}
