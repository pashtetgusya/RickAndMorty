import Foundation

// MARK: - Rick and Morty character list model

/// Модель данных списка персонажей из вселенной `"Rick and Morty"`.
enum RnMCharacterListModel {
    
    // MARK: Character
    
    /// Структура, описывающая модель персонажа для отображения в списке.
    ///
    /// Содержит основную информацию о персонаже
    /// (идентификатор, имя, статус и ссылку на изображение).
    struct Character: Equatable, Hashable {
        
        // MARK: Properties
        
        /// Идентификатор персонажа.
        let id: Int
        
        /// Имя персонажа.
        let name: String
        /// Пол персонажа.
        let gender: String
        /// Вид (расса) персонажа.
        let species: String
        /// Текущий статус персонажа.
        let status: String
        /// Ссылка на изображение персонажа.
        let imageURL: URL
        
        // MARK: Initialization
        
        /// Создает новый экземпляр структуры.
        /// - Parameter dto: `DTO` объект с информацией о персонаже.
        init(dto: RnMCharacterDTO) {
            self.id = dto.id
            self.name = dto.name
            self.gender = dto.gender.rawValue
            self.species = dto.species
            self.status = dto.status.rawValue
            self.imageURL = dto.imageURL
        }
        
        // MARK: Hashable protocol implementation
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        // MARK: Equatable protocol implementation
        
        static func == (lhs: Character, rhs: Character) -> Bool {
            lhs.id == rhs.id
        }
    }
}
