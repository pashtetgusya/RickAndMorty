import Foundation
import Combine

// MARK: - Rick and Morty character info table header view model

/// Вью модель хедера таблицы информации о персонаже из вселенной `"Rick and Morty"`.
@MainActor final class RnMCharacterInfoTableHeaderViewModel {
    
    // MARK: Services
    
    private let imageProvider: ImageProvider
    
    // MARK: Properties
    
    /// Флаг выполнения загрузки изображения персонажа.
    @Published var isLoading: Bool = false
    /// Данные изображения персонажа.
    @Published var characterImageData: Data = Data()
    /// Ссылка на загрузку изображения персонажа.
    private let imageURL: URL
    
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
    func loadCharacterImage() {
        guard loadCharacterImageTask == nil else { return }
        defer { loadCharacterImageTask = nil }
        
        loadCharacterImageTask = Task {
            defer { isLoading = false }
            isLoading = true
            
            let imageData = await imageProvider.image(for: imageURL)
            characterImageData = imageData ?? Data()
        }
    }
    
    /// Отменяет загрузку изображения персонажа.
    func cancelLoadCharacterImage() {
        loadCharacterImageTask?.cancel()
        loadCharacterImageTask = nil
    }
}
