import Foundation

// MARK: - Characters HTTP request filter

/// Структура, описывающая параметры фильтрации
/// для запроса списка персожаней из вселенной `"Rick and Morty"`.
public struct CharactersHTTPRequestFilter: Sendable {
    
    // MARK: Properties
    
    /// Номер страницы списка персонажей.
    let page: Int?
    /// Фильтр по имени персонажа.
    let name: String?
    /// Фильтр по статусу персонажа.
    let status: CharacterStatusDTO?
    /// Фильтр по виду (расе) персонажа.
    let species: String?
    /// Фильтр по типу/подвиду персонажа.
    let type: String?
    /// Фильтр по полу персонажа.
    let gender: CharacterGenderDTO?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameters:
    ///   - page: номер страницы (по умолчанию `nil`).
    ///   - name: имя персонажа (по умолчанию `nil`).
    ///   - status: статус персонажа (по умолчанию `nil`).
    ///   - species: вид персонажа (по умолчанию `nil`).
    ///   - type: подвид персонажа (по умолчанию `nil`).
    ///   - gender: пол персонажа (по умолчанию `nil`).
    public init(
        page: Int? = nil,
        name: String? = nil,
        status: CharacterStatusDTO? = nil,
        species: String? = nil,
        type: String? = nil,
        gender: CharacterGenderDTO? = nil
    ) {
        self.page = page
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
    }
}
