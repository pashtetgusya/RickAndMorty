import Foundation
import Data

// MARK: - Episode info

/// Структура, описывающая модель подромной информации об эпизоде.
public struct EpisodeInfo: Sendable {
    
    // MARK: Properties
    
    /// Идентификатор эпизода.
    public let id: Int
    /// Название эпизода.
    public let name: String
    /// Номер эпизода в сезоне.
    public let number: Int
    /// Номер сезона.
    public let season: Int
    /// Дата выхода эпизода.
    public let releaseDate: Date
    /// Список имен персонажей, которые встречаются в эпизоде.
    public let characterNamesThatAppeared: [String]
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - episodeDTO: `DTO` объект с информацией об эпизоде.
    ///   - characterDTOList: список `DTO` объектот с информацией о персонажах.
    public init(
        episodeDTO: EpisodeDTO,
        characterDTOList: [CharacterDTO]
    ) {
        self.id = episodeDTO.id
        self.name = episodeDTO.name
        
        let code = episodeDTO.code
        let startIndex = code.startIndex
        let season = code[code.index(after: startIndex)...code.index(startIndex, offsetBy: 2)]
        let number = code[code.index(startIndex, offsetBy: 4)...]
        self.number = Int(number) ?? 1
        self.season = Int(season) ?? 1
        
        let strategy = Date.ParseStrategy(
            format: "\(month: .wide) \(day: .defaultDigits), \(year: .defaultDigits)",
            locale: Locale(identifier: "en_US"),
            timeZone: TimeZone.current
        )
        self.releaseDate = (try? Date(episodeDTO.releaseDate, strategy: strategy)) ?? .now
        self.characterNamesThatAppeared = characterDTOList.map { $0.name }
    }
}
