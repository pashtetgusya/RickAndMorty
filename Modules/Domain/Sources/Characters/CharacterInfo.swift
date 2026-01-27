import Foundation
import Data

// MARK: - Character info

/// Структура, описывающая модель подробной информации о персонаже.
public struct CharacterInfo: Sendable {
    
    // MARK: Properties
    
    /// Идентификатор персонажа.
    public let id: Int
    /// Имя персонажа.
    public let name: String
    /// Пол персонажа.
    public let gender: String
    /// Вид (расса) персонажа.
    public let species: String
    /// Текущий статус персонажа.
    public let status: String
    /// Ссылка на изображение персонажа.
    public let imageURL: URL
    /// Название первоначального местоположения персонажа.
    public let originLocationName: String
    /// Название последнего известного местоположения персонажа.
    public let lastLocationName: String
    /// Список названий эпизодов, в которых появлялся персонаж.
    public let episodeNamesInWhichAppeared: [String]
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameters:
    ///   - characterDTO: `DTO` объект с информацией о персонаже.
    ///   - episodeDTOList: список `DTO` объектов с информацией об эпиздах.
    public init(
        characterDTO: CharacterDTO,
        episodeDTOList: [EpisodeDTO]
    ) {
        self.id = characterDTO.id
        self.name = characterDTO.name
        self.species = characterDTO.species
        self.status = characterDTO.status.rawValue
        self.gender = characterDTO.gender.rawValue
        self.imageURL = characterDTO.imageURL
        self.originLocationName = characterDTO.originLocation.name
        self.lastLocationName = characterDTO.lastLocation.name
        self.episodeNamesInWhichAppeared = episodeDTOList.map {
            $0.code + ": " + $0.name
        }
    }
}
