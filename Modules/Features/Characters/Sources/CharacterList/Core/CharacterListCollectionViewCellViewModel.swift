import Foundation
import Combine
import Data

// MARK: - Сharacter list collection view cell view model

/// Вью модель ячейки отображения персонажа из вселенной `"Rick and Morty"`.
@MainActor final class CharacterListCollectionViewCellViewModel {
    
    // MARK: Properties
    
    /// Отображаемый в ячейке персонаж.
    let character: CharacterListCollectionViewModel.Section.Row
    /// Флаг выполнения загрузки изображения персонажа.
    @Published var isLoading: Bool
    /// Данные изображения персонажа.
    @Published var characterImageData: Data?
    
    /// Репозиторий для получения изображений.
    private let imageRepository: ImageRepository?
    /// Задача на загрузку изображения персонажа.
    private var loadCharacterImageTask: Task<Void, Never>?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter character: отображаемый персонаж.
    /// - Parameter imageRepository: репозиторий для получения изображений.
    init(
        character: CharacterListCollectionViewModel.Section.Row,
        imageRepository: ImageRepository?
    ) {
        self.isLoading = false
        self.character = character
        
        self.imageRepository = imageRepository
    }
}

// MARK: Load image functions

extension CharacterListCollectionViewCellViewModel {
    
    /// Выполняет загрузку изображения персонажа.
    func loadCharacterImage() {
        guard loadCharacterImageTask == nil else { return }
        
        defer { loadCharacterImageTask = nil }
        
        loadCharacterImageTask = Task { [weak self] in
            guard let self else { return }
            
            defer { isLoading = false }
            isLoading = true
            
            let imageData = await imageRepository?.image(for: character.imageURL)
            characterImageData = imageData
        }
    }
    
    /// Отменяет загрузку изображения персонажа.
    func cancelLoadCharacterImage() {
        loadCharacterImageTask?.cancel()
        loadCharacterImageTask = nil
    }
}
