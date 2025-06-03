import Foundation

// MARK: - Rick and Morty character info table header view model

/// Вью модель хедера таблицы информации о персонаже из вселенной `"Rick and Morty"`.
@MainActor final class RnMCharacterInfoTableHeaderViewModel {
    
    // MARK: Services
    
    private let imageProvider: ImageProvider
    
    // MARK: Properties
    
    /// Ссылка на загрузку изображения персонажа.
    private let imageURL: URL
    
    /// Замыкание, которое будет вызвано по окончании загрузки изображения персонажа.
    private var loadCharacterImageCompletion: ((Data?) -> Void)?
    /// Задача на загрузку изображения персонажа.
    private var loadCharacterImageTask: Task<Void, Never>?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - imageURL: ссылка на загрузку изображения персонажа.
    init(
        imageURL: URL,
        imageProvider: ImageProvider
    ) {
        self.imageProvider = imageProvider
        
        self.imageURL = imageURL
    }
    
    // MARK: Functions
    
    /// Выполняет загрузку изображения персонажа.
    /// - Parameter completion: замыкание, которое выполнится по окончании загрузки.
    func loadCharacterImage(with completion: ((Data?) -> Void)?) {
        loadCharacterImageCompletion = completion
        
        guard loadCharacterImageTask == nil else { return }
        defer { loadCharacterImageTask = nil }
        
        loadCharacterImageTask = Task {
            let image = await imageProvider.image(for: imageURL)
            loadCharacterImageCompletion?(image)
        }
    }
    
    /// Отменяет загрузку изображения персонажа.
    func cancelLoadCharacterImage() {
        loadCharacterImageCompletion = nil
        
        loadCharacterImageTask?.cancel()
        loadCharacterImageTask = nil
    }
}
