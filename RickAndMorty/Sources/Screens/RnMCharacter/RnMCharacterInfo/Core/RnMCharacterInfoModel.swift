import UIKit

// MARK: - Rick and Morty character info model

/// Модель данных информации о персонаже из вселенной `"Rick and Morty"`.
enum RnMCharacterInfoModel {
    
    // MARK: Character info
    
    /// Структура описания просматриваемой информации о персонаже.
    struct CharacterInfo {
        
        // MARK: Properties
        
        /// Имя персонажа.
        let name: String
        /// Пол персонажа.
        let gender: String
        /// Текущий статус персонажа.
        let status: String
        
        /// Ссылка на изображение персонажа.
        let imageURL: URL
        
        /// Название первоначального местоположения персонажа.
        let originLocationName: String
        /// Название последнего известного местоположения персонажа.
        let lastLocationName: String
        
        /// Список названий эпизодов, в которых появлялся персонаж.
        let episodeNamesInWhichAppeared: [String]
        
        // MARK: Initialization
        
        /// Создает новый экземпляр структуры.
        /// - Parameters:
        ///   - characterInfoDTO: `DTO` объект с информацией о персонаже.
        ///   - episodeDTOList: список `DTO` объектов с информацией об эпиздах.
        init(
            characterInfoDTO: RnMCharacterDTO,
            episodeDTOList: [RnMEpisodeDTO]
        ) {
            self.name = characterInfoDTO.name
            self.status = characterInfoDTO.status.rawValue
            self.gender = characterInfoDTO.gender.rawValue
            
            self.imageURL = characterInfoDTO.imageURL
            
            self.originLocationName = characterInfoDTO.originLocation.name
            self.lastLocationName = characterInfoDTO.lastLocation.name
            
            self.episodeNamesInWhichAppeared = episodeDTOList.map {
                $0.code + ": " + $0.name
            }
        }
        
        // MARK: Convert functions
        
        /// Выполняет преобразование структуры в список секций с параметрами персонажа для отображения.
        /// - Returns: список секций с параметрами персонажа.
        func toSectionList() -> [RnMCharacterInfoModel.Section] {
            let detailsSection = RnMCharacterInfoModel.Section(type: .details, rows: [
                RnMCharacterInfoModel.CharacterInfoParameter.status(description: status).erased(),
                RnMCharacterInfoModel.CharacterInfoParameter.gender(description: gender).erased(),
                RnMCharacterInfoModel.CharacterInfoParameter.originLocation(description: originLocationName).erased(),
                RnMCharacterInfoModel.CharacterInfoParameter.lastLocation(description: lastLocationName).erased(),
            ])
            let episodesSection = RnMCharacterInfoModel.Section(type: .episodes, rows: episodeNamesInWhichAppeared.map {
                RnMCharacterInfoModel.CharacterInfoParameter.episode(description: $0).erased()
            })
            let sectionList = [detailsSection, episodesSection]
            
            return sectionList
        }
    }
    
    // MARK: Character info section
    
    /// Структура описания секции таблицы информации о персонаже.
    struct Section: Equatable, Hashable {
        
        // MARK: Character info section type
        
        /// Перечень возможных вариантов
        /// секций таблцы информации о персонаже.
        enum SType: Int, Equatable, Hashable {
            
            // MARK: Cases
            
            /// Детали о персонаже.
            case details
            /// Список эпизодов в которых встречался персонаж.
            case episodes
        }
        
        // MARK: Properties
        
        /// Тип секции.
        let type: RnMCharacterInfoModel.Section.SType
        /// Перечень ячеек секции.
        let rows: [AnyParameter]
    }
    
    // MARK: Character info parameter
    
    /// Перечень возможных параметров информации о персонаже.
    enum CharacterInfoParameter: Parameter {
        
        // MARK: Cases
        
        /// Статус персонажа.
        case status(description: String)
        /// Пол персонажа.
        case gender(description: String)
        /// Локация происхождения персонажа.
        case originLocation(description: String)
        /// Последнее известное местоположение персонажа.
        case lastLocation(description: String)
        /// Эпизод в котором встречается персонаж.
        case episode(description: String)
        
        // MARK: Properties
        
        var icon: Data {
            switch self {
            case .status: UIImage.characterInfoStatusIcon.pngData() ?? Data()
            case .gender: UIImage.characterInfoGenderIcon.pngData() ?? Data()
            case .originLocation: UIImage.characterInfoOriginLocationIcon.pngData() ?? Data()
            case .lastLocation: UIImage.characterInfoLastLocationIcon.pngData() ?? Data()
            case .episode: UIImage.characterInfoEpisodeIcon.pngData() ?? Data()
            }
        }
        var name: String {
            switch self {
            case .status: "Status"
            case .gender: "Gender"
            case .originLocation: "Origin"
            case .lastLocation: "Location"
            case .episode: "Episode"
            }
        }
        var description: String {
            switch self {
            case .status(let description): description
            case .gender(let description): description
            case .originLocation(let description): description
            case .lastLocation(let description): description
            case .episode(let description): description
            }
        }
    }
}
