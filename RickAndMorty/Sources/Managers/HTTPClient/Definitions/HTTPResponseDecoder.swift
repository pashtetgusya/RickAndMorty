import Foundation

// MARK: - HTTP response decoder protocol

/// Протокол, определяющий интерфейс для преобразования данных HTTP-ответов в Decodable-типы.
protocol HTTPResponseDecoder: Sendable {
    
    /// Выполняет преобразование данных в указанный Decodable-тип..
    /// - Parameters:
    ///   - type: тип, в который нужно преобразовать данные.
    ///   - data: данные для преобразования.
    /// - Returns: Готовый объект указанного типа.
    /// - Throws: Может выбросить ошибку, если процесс декодирования завершился неудачно.
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}
