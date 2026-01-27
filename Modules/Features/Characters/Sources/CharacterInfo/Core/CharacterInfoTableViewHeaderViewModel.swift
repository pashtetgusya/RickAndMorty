import Foundation
import Combine
import Data

// MARK: - Character info table view header view model

/// Вью модель хедера таблицы информации о персонаже из вселенной `"Rick and Morty"`.
@MainActor final class CharacterInfoTableViewHeaderViewModel {
    
    // MARK: Properties
    
    /// Флаг выполнения загрузки изображения персонажа.
    @Published var isLoading: Bool = false
    /// Данные изображения персонажа.
    @Published var characterImageData: Data = Data()
    /// Ссылка на загрузку изображения персонажа.
    private let imageURL: URL?
    
    /// Репозиторий для получения изображений.
    private let imageRepository: ImageRepository
    /// Задача на загрузку изображения персонажа.
    private var loadCharacterImageTask: Task<Void, Never>?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - imageURL: ссылка на загрузку изображения персонажа.
    ///   - imageRepository: репозиторий для получения изображений.
    init(
        imageURL: URL?,
        imageRepository: ImageRepository
    ) {
        self.imageURL = imageURL
        
        self.imageRepository = imageRepository
    }
}
 
// MARK: Load image functions

extension CharacterInfoTableViewHeaderViewModel {
    
    /// Выполняет загрузку изображения персонажа.
    func loadCharacterImage() {
        guard loadCharacterImageTask == nil else { return }
        
        defer { loadCharacterImageTask = nil }
        loadCharacterImageTask = Task { [weak self] in
            guard let imageURL = self?.imageURL else { return }
            
            defer { self?.isLoading = false }
            self?.isLoading = true
            
            let imageData = await self?.imageRepository.image(for: imageURL)
            self?.characterImageData = imageData ?? Data()
        }
    }
    
    /// Отменяет загрузку изображения персонажа.
    func cancelLoadCharacterImage() {
        loadCharacterImageTask?.cancel()
        loadCharacterImageTask = nil
    }
}
