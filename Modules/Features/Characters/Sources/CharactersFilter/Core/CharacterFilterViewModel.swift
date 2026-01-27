import Foundation
import Combine
import UIComponents

// MARK: - Сharacter filter view model

/// Вью модель экрана списка фильтров для персонажей из вселенной `"Rick and Morty"`.
@MainActor final class CharacterFilterViewModel {
    
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
    let currentFilter: CharacterFilterTableViewModel.CharacterFilter
    /// Новые параметры фильтрации для персонажей.
    @Published var newFilter: CharacterFilterTableViewModel.CharacterFilter
    /// Список секций с фильтрами для персонажей.
    @Published var filterList: [CharacterFilterTableViewModel.Section]
    
    /// Замыкание, возвращающее новые параметры фильтрации для персонажей.
    private var didFinishCompletion: (CharacterFilterTableViewModel.CharacterFilter) -> Void
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - currentFilter: текущие параметры фильтрации для персонажей.
    ///   - completion: замыкание, возвращающее новые параметры фильтрации для персонажей.
    init(
        with currentFilter: CharacterFilterTableViewModel.CharacterFilter,
        completion: @escaping @Sendable (CharacterFilterTableViewModel.CharacterFilter) -> Void
    ) {
        self.hasChanges = false
        self.currentFilter = currentFilter
        self.newFilter = currentFilter
        self.didFinishCompletion = completion
        
        self.filterList = [
            CharacterFilterTableViewModel.Section(type: .status),
            CharacterFilterTableViewModel.Section(type: .gender)
        ]
    }
}

// MARK: - View model filter functions

extension CharacterFilterViewModel {
    
    /// Выполняет установку нового значения фильтра для персонажей.
    /// - Parameter filter: новое значение фильтра.
    func setNewFilter(_ filter: AnyFilter) {
        if let genderFilter = filter.asFilter(CharacterFilterTableViewModel.Section.Row.Gender.self) {
            newFilter.gender = genderFilter
        }
        else if let statusFilter = filter.asFilter(CharacterFilterTableViewModel.Section.Row.Status.self) {
            newFilter.status = statusFilter
        }
    }
    
    /// Выполняет применение фильтра для персонажей.
    func applyFilter() {
        didFinishCompletion(newFilter)
    }
}
