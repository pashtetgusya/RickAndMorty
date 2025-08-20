import Foundation

// MARK: - Rick and Morty character filter model

/// Модель данных списка фильтров для персонажей из вселенной `"Rick and Morty"`.
enum RnMCharacterFilterModel {
    
    // MARK: Character filter section
    
    /// Структура описания секции таблицы списка фильтров для персонажей.
    struct Section: Equatable, Hashable {
        
        // MARK: Character filter section type
        
        /// Перечень позможных вариантов
        /// секций таблцы списка фильтров для персонажей.
        enum SType: Int, Equatable, Hashable {
            
            // MARK: Cases
            
            case gender
            case status
        }
        
        // MARK: Properties
        
        /// Тип секции.
        let type: RnMCharacterFilterModel.Section.SType
        /// Перечень ячеек секции.
        var rows: [AnyFilter] {
            switch type {
            case .gender: RnMCharacterFilterModel.CharacterGenderFilter.allCases.map { $0.erased() }
            case .status: RnMCharacterFilterModel.CharacterStatusFilter.allCases.map { $0.erased() }
            }
        }
    }
    
    // MARK: Character filter
    
    /// Структура описания фильтра для персонажей.
    struct CharacterFilter: Equatable, Hashable {
        
        // MARK: Properties
        
        /// Фильтр списка персонажей по половому признаку
        var gender: RnMCharacterFilterModel.CharacterGenderFilter
        /// Фильтр списка персонажей по статусу.
        var status: RnMCharacterFilterModel.CharacterStatusFilter
    }
    
    // MARK: Character gender filter
    
    /// Перечень позможных вариантов
    /// фильтрации списка персонажей по половому признаку.
    enum CharacterGenderFilter: String, Filter, CaseIterable {
        
        // MARK: Cases
        
        case female
        case male
        case genderless
        case unknown
        case empty = ""
        
        // MARK: Properties
        
        static var allCases: [RnMCharacterFilterModel.CharacterGenderFilter] {
            [.female, .male, .genderless, .unknown]
        }
    }
    
    // MARK: Character status filter
    
    /// Перечень позможных вариантов
    /// фильтрации списка персонажей по статусу.
    enum CharacterStatusFilter: String, Filter, CaseIterable {
        
        // MARK: Cases
        
        case alive
        case dead
        case unknown
        case empty = ""
        
        // MARK: Properties
        
        static var allCases: [RnMCharacterFilterModel.CharacterStatusFilter] {
            [.alive, .dead, .unknown]
        }
    }
}
