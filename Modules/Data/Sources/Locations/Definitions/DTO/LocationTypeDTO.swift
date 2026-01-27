import Foundation

// MARK: - Location type DTO

/// Энам, описывающий `DTO` объект возможных вариантов
/// локаций во вселенной `"Rick and Morty"`.
public enum LocationTypeDTO: String, Decodable, Sendable {
    
    // MARK: Cases
    
    case acidPlant = "Acid Plant"
    case arcade = "Arcade"
    case artificiallyGeneratedWorld = "Artificially generated world"
    case asteroid = "Asteroid"
    case base = "Base"
    case box = "Box"
    case cluster = "Cluster"
    case consciousness = "Consciousness"
    case convention = "Convention"
    case country = "Country"
    case customs = "Customs"
    case daycare = "Daycare"
    case deathStar = "Death Star"
    case diegesis = "Diegesis"
    case dimension = "Dimension"
    case dream = "Dream"
    case dwarfPlanet = "Dwarf planet (Celestial Dwarf)"
    case elementalRings = "Elemental Rings"
    case fantasyTown = "Fantasy town"
    case game = "Game"
    case hell = "Hell"
    case human = "Human"
    case liquid = "Liquid"
    case machine = "Machine"
    case memory = "Memory"
    case menagerie = "Menagerie"
    case microverse = "Microverse"
    case miniverse = "Miniverse"
    case mount = "Mount"
    case nightmare = "Nightmare"
    case nonDiegeticAlternativeReality = "Non-Diegetic Alternative Reality"
    case planet = "Planet"
    case policeDepartment = "Police Department"
    case quadrant = "Quadrant"
    case quasar = "Quasar"
    case reality = "Reality"
    case resort = "Resort"
    case spa = "Spa"
    case space = "Space"
    case spaceStation = "Space station"
    case spacecraft = "Spacecraft"
    case tv = "TV"
    case teenyverse = "Teenyverse"
    case woods = "Woods"
    case unknown = "unknown"
    case none = ""
}
