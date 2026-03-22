import Foundation
import Data

// MARK: - Episode

/// Структура, описывающая модель эпизода.
///
/// Содержит основную информацию об эпизоде
/// (идентификатор, название и код).
public struct Episode: Equatable, Hashable, Sendable {
    
    // MARK: Properties
    
    /// Идентификатор эпизода.
    public let id: Int
    /// Название эпизода.
    public let name: String
    /// Номер эпизода в сезоне.
    public let number: Int
    /// Номер сезона.
    public let season: Int
    
    // MARK: Initialization
    
    /// Создает новый экземпляр структуры.
    /// - Parameter dto: `DTO` объект с информацией об эпизоде.
    public init(dto: EpisodeDTO) {
        self.id = dto.id
        self.name = dto.name
        
        let code = dto.code
        let startIndex = code.startIndex
        let season = code[code.index(after: startIndex)...code.index(startIndex, offsetBy: 2)]
        let number = code[code.index(startIndex, offsetBy: 4)...]
        self.number = Int(number) ?? 1
        self.season = Int(season) ?? 1
    }
    
    // MARK: Hashable protocol implementation
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: Equtable protocol implementation
    
    public static func == (lhs: Episode, rhs: Episode) -> Bool {
        lhs.id == rhs.id
    }
}
