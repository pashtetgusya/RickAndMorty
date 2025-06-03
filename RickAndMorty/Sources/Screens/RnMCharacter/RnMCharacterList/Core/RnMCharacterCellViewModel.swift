import Foundation

// MARK: - Rick and Morty character cell view model

/// Вью модель ячейки отображения персонажа из вселенной `"Rick and Morty"`.
@MainActor final class RnMCharacterCellViewModel {
    
    // MARK: Services
    
    private let imageProvider: ImageProvider
    
    // MARK: Properties
    
    /// Отображаемый в ячейке персонаж из вселенной `"Rick and Morty"`.
    let character: RnMCharacterListModel.Character
    
    /// Замыкание, которое будет вызвано по окончании загрузки изображения персонажа.
    private var loadCharacterImageCompletion: ((Data?) -> Void)?
    /// Задача на загрузку изображения персонажа.
    private var loadCharacterImageTask: Task<Void, Never>?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter character: отображаемый персонаж.
    init(
        character: RnMCharacterListModel.Character,
        imageProvider: ImageProvider
    ) {
        self.character = character
        self.imageProvider = imageProvider
    }
    
    // MARK: Functions
    
    /// Выполняет загрузку изображения персонажа.
    /// - Parameter completion: замыкание, которое выполнится по окончании загрузки.
    func loadCharacterImage(with completion: ((Data?) -> Void)?) {
        loadCharacterImageCompletion = completion
        
        guard loadCharacterImageTask == nil else { return }
        defer { loadCharacterImageTask = nil }
        
        loadCharacterImageTask = Task {
            let image = await imageProvider.image(for: character.imageURL)
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
