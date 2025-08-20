import Foundation
import Combine

// MARK: - Rick and Morty character cell view model

/// Вью модель ячейки отображения персонажа из вселенной `"Rick and Morty"`.
@MainActor final class RnMCharacterCellViewModel {
    
    // MARK: Services
    
    private let imageProvider: ImageProvider?
    
    // MARK: Properties
    
    /// Флаг выполнения загрузки изображения персонажа.
    @Published var isLoading: Bool
    /// Данные изображения персонажа.
    @Published var characterImageData: Data?
    /// Отображаемый в ячейке персонаж из вселенной `"Rick and Morty"`.
    let character: RnMCharacterListModel.Character
    
    /// Задача на загрузку изображения персонажа.
    private var loadCharacterImageTask: Task<Void, Never>?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter character: отображаемый персонаж.
    init(
        character: RnMCharacterListModel.Character,
        imageProvider: ImageProvider?
    ) {
        self.imageProvider = imageProvider
        
        self.isLoading = false
        self.character = character
    }
    
    // MARK: Functions
    
    /// Выполняет загрузку изображения персонажа.
    func loadCharacterImage() {
        guard loadCharacterImageTask == nil else { return }
        defer { loadCharacterImageTask = nil }
        
        loadCharacterImageTask = Task {
            defer { isLoading = false }
            isLoading = true
            
            let imageData = await imageProvider?.image(for: character.imageURL)
            characterImageData = imageData
        }
    }
    
    /// Отменяет загрузку изображения персонажа.
    func cancelLoadCharacterImage() {
        loadCharacterImageTask?.cancel()
        loadCharacterImageTask = nil
    }
}
