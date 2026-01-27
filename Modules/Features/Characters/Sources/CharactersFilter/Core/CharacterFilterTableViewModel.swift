import Foundation
import UIComponents

// MARK: - Character filter table view model

/// Модель данных списка фильтров для персонажей из вселенной `"Rick and Morty"`.
enum CharacterFilterTableViewModel {
    
    // MARK: Character filter
    
    /// Структура, описывающая фильтр для персонажей.
    struct CharacterFilter: Equatable, Hashable {
        
        // MARK: Properties
        
        /// Фильтр списка персонажей по половому признаку
        var gender: CharacterFilterTableViewModel.Section.Row.Gender
        /// Фильтр списка персонажей по статусу.
        var status: CharacterFilterTableViewModel.Section.Row.Status
    }
    
    // MARK: Character filter section
    
    /// Структура, описывающая секцию таблицы списка фильтров для персонажей.
    struct Section: Equatable, Hashable {
        
        // MARK: Properties
        
        /// Тип секции.
        let type: CharacterFilterTableViewModel.Section.`Type`
        /// Перечень ячеек секции.
        var rows: [CharacterFilterTableViewModel.Section.Row] {
            switch type {
            case .gender: CharacterFilterTableViewModel.Section.Row.Gender.allCases
            case .status: CharacterFilterTableViewModel.Section.Row.Status.allCases
            }
        }
    }
}

// MARK: - Character filter table view section type

extension CharacterFilterTableViewModel.Section {
    
    /// Энам, описывающий перечень возможных вариантов
    /// секций таблцы списка фильтров для персонажей.
    enum `Type`: Int, Equatable, Hashable {
        
        // MARK: Cases
        
        case gender
        case status
    }
}

// MARK: - Character filter table view section row

extension CharacterFilterTableViewModel.Section {
    
    typealias Row = AnyFilter
}

// MARK: -

extension CharacterFilterTableViewModel.Section.Row {
    
    // MARK: Character gender filter
    
    /// Энам, описывающий перечень возможных вариантов
    /// фильтрации списка персонажей по половому признаку.
    enum Gender: String, Filter, CaseIterable {
        
        // MARK: Cases
        
        case female = "Female"
        case male = "Male"
        case genderless = "Genderless"
        case unknown
        case empty = ""
        
        // MARK: Properties
        
        static var allCases: [CharacterFilterTableViewModel.Section.Row] {
            [
                Gender.female,
                Gender.male,
                Gender.genderless,
                Gender.unknown
            ].map { $0.erased }
        }
    }
    
    // MARK: Character status filter
    
    /// Энам, описывающий перечень возможных вариантов
    /// фильтрации списка персонажей по статусу.
    enum Status: String, Filter, CaseIterable {
        
        // MARK: Cases
        
        case alive = "Alive"
        case dead = "Dead"
        case unknown
        case empty = ""
        
        // MARK: Properties
        
        static var allCases: [CharacterFilterTableViewModel.Section.Row] {
            [
                Status.alive,
                Status.dead,
                Status.unknown
            ].map { $0.erased }
        }
    }

}
