import Foundation
import Combine

// MARK: - Network monitor protocol

/// Интерфейс сервиса для мониторинга состояния сетевого подключения.
protocol NetworkMonitor: Sendable {
    
    // MARK: Properties
    
    /// Флаг доступности подключения к сети.
    var isReachable: Bool { get }
    /// Паблишер флага доступности подключения к сети.
    var isReachablePublisher: AnyPublisher<Bool, Never> { get }
    /// Статус подключения к сети.
    var state: NetworkConnectionState { get }
    /// Паблишер флага доступности подключения к сети.
    var statePublisher: AnyPublisher<NetworkConnectionState, Never> { get }
    
    // MARK: Functions
    
    /// Запускает мониторинг состояния сетевого подключения.
    func start()
    /// Останавливает мониторинг состояния сетевого подключения.
    func stop()
}
