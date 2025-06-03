import Foundation
import Combine

// MARK: - Rick and Morty character filter view model

/// Вью модель экрана списка фильтров для персонажей из вселенной `"Rick and Morty"`.
@MainActor final class RnMCharacterFilterViewModel {
    
    // MARK: Properties
    
    /// Флаг наличия изменений.
    var hasChanges: Bool
    /// Паблишер флага наличия изменений.
    var hasChangesPublisher: AnyPublisher<Bool, Never> {
        $newFilter
            .map { [weak self] newFilter in
                let hasChanges = self?.currentFilter != newFilter
                self?.hasChanges = hasChanges
                
                return hasChanges
            }
            .eraseToAnyPublisher()
    }
    
    /// Текущие параметры фильтрации для персонажей.
    let currentFilter: RnMCharacterFilterModel.CharacterFilter
    /// Новые параметры фильтрации для персонажей.
    @Published private var newFilter: RnMCharacterFilterModel.CharacterFilter
    /// Список секций с фильтрами для персонажей.
    @Published var filterList: [RnMCharacterFilterModel.Section]
    
    
    private var didFinishCompletion: (RnMCharacterFilterModel.CharacterFilter) -> Void
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - currentFilter: текущие параметры фильтрации для персонажей.
    ///   - completion: замыкание, возвращающее новые параметры фильтрации для персонажей.
    init(
        with currentFilter: RnMCharacterFilterModel.CharacterFilter,
        completion: @escaping (RnMCharacterFilterModel.CharacterFilter) -> Void
    ) {
        self.hasChanges = false
        self.currentFilter = currentFilter
        self.newFilter = currentFilter
        self.didFinishCompletion = completion
        
        self.filterList = [
            RnMCharacterFilterModel.Section(type: .status),
            RnMCharacterFilterModel.Section(type: .gender),
        ]
    }
}

// MARK: - View model filter functions

extension RnMCharacterFilterViewModel {
    
    /// Устанавливает новое значение фильтра для персонажей.
    /// - Parameter filter: новое значение фильтра.
    func setNewFilter(_ filter: AnyFilter) {
        if let genderFilter = filter.nonErasedValue(
            as: RnMCharacterFilterModel.CharacterGenderFilter.self
        ) {
            newFilter.gender = genderFilter
        }
        else if let statusFilter = filter.nonErasedValue(
            as: RnMCharacterFilterModel.CharacterStatusFilter.self
        ) {
            newFilter.status = statusFilter
        }
    }
    
    /// Применяет фильтр для персонажей.
    func applyFilter() {
        didFinishCompletion(newFilter)
    }
}
