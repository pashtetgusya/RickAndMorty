import Foundation
import Domain

// MARK: - Character list collection view model

/// Модель данных коллекции экрана списка персонажей из вселенной `"Rick and Morty"`.
enum CharacterListCollectionViewModel {
    
    // MARK: Character info section
    
    /// Структура, описывающая секцию коллекции списка персонажей.
    struct Section: Equatable, Hashable {
        
        // MARK: Properties
        
        /// Тип секции.
        let type: CharacterListCollectionViewModel.Section.`Type`
        /// Перечень ячеек секции.
        let rows: [CharacterListCollectionViewModel.Section.Row]
    }
}

// MARK: - Character list collection view model section type

extension CharacterListCollectionViewModel.Section {
    
    /// Энам, описывающий перечень возможных вариантов
    /// секций таблцы списка персонажей.
    enum `Type`: Int, Equatable, Hashable {
        
        // MARK: Cases
        
        /// Список персонажей.
        case characters
    }
}

// MARK: - Character list collection view model section row

extension CharacterListCollectionViewModel.Section {
    
    /// Структура, описывающая ячейку таблицы списка персонажей.
    typealias Row = Character
}
