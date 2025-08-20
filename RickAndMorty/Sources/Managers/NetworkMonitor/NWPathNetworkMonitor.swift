import Foundation
import Combine
import Network

// MARK: - NW path network monitor

/// Класс, реализующй нтерфейс сервиса для мониторинга состояния сетевого подключения на основе NWPathMonitor.
final class NWPathNetworkMonitor: NetworkMonitor, @unchecked Sendable {
    
    // MARK: Properties
    
    @Published var isReachable: Bool
    @Published var state: NetworkConnectionState
    
    var isReachablePublisher: AnyPublisher<Bool, Never> { $isReachable.eraseToAnyPublisher() }
    var statePublisher: AnyPublisher<NetworkConnectionState, Never> { $state.eraseToAnyPublisher() }
    
    /// Объект мониторинга подключения к мобильной сети.
    private let cellularNWPathMonitor: NWPathMonitor
    /// Объект мониторинга подключения к сети Wi-Fi.
    private let wifiNWPathMonitor: NWPathMonitor
    
    /// Очередь на которой работает объект мониторинга подключения к мобильной сети.
    private let cellularQueue: DispatchQueue
    /// Очередь на которой работает объект мониторинга подключения к сети Wi-Fi.
    private let wifiQueue: DispatchQueue
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init() {
        self.isReachable = false
        self.state = .unreachable
        
        self.cellularQueue = DispatchQueue(label: "NWPathNetworkMonitor.cellularNWPathMonitor.queue", target: .main)
        self.wifiQueue = DispatchQueue(label: "NWPathNetworkMonitor.wifiNWPathMonitor.queue", target: .main)
        
        self.cellularNWPathMonitor = NWPathMonitor(requiredInterfaceType: .cellular)
        self.wifiNWPathMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
        
        self.setupPathUpdateHandlers()
    }
    
    // MARK: Functions
    
    func start() {
        cellularNWPathMonitor.start(queue: cellularQueue)
        wifiNWPathMonitor.start(queue: wifiQueue)
    }
    
    func stop() {
        cellularNWPathMonitor.cancel()
        wifiNWPathMonitor.cancel()
    }
}

// MARK: - Network monitor setup functions

private extension NWPathNetworkMonitor {
    
    /// Выполняет настройку замыкания обратного вызова, сообщающего о статусе подключения к сети.
    func setupPathUpdateHandlers() {
        self.cellularNWPathMonitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isReachable = true
                self?.state = .reachable(withType: .cellular)
            }
            else if self?.wifiNWPathMonitor.currentPath.status != .satisfied {
                self?.isReachable = false
                self?.state = .unreachable
            }
        }
        self.wifiNWPathMonitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isReachable = true
                self?.state = .reachable(withType: .wifi)
            }
            else if self?.cellularNWPathMonitor.currentPath.status != .satisfied {
                self?.isReachable = false
                self?.state = .unreachable
            }
        }
    }
}
