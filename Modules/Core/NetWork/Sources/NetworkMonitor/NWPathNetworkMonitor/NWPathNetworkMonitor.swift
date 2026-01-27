import Foundation
import Combine
import Network
import ToolBox

// MARK: - NW path network monitor

/// Класс, реализующй интерфейс сервиса для мониторинга
/// состояния сетевого подключения на основе `NWPathMonitor`.
public final class NWPathNetworkMonitor: @unchecked Sendable {
    
    // MARK: Properties
    
    public var isReachable: Bool { isReachableSubject.value }
    public var isReachablePublisher: AnyPublisher<Bool, Never> {
        isReachableSubject.eraseToAnyPublisher()
    }
    public var state: NetworkConnectionState { stateSubject.value }
    public var statePublisher: AnyPublisher<NetworkConnectionState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    /// Сабджект текущего значения доступности подключения к сети
    @Atomic private var isReachableSubject: CurrentValueSubject<Bool, Never>
    /// Сабджект текущего значения статус подключения к сети.
    @Atomic private var stateSubject: CurrentValueSubject<NetworkConnectionState, Never>
    
    /// Объект мониторинга подключения к мобильной сети.
    private let cellularNWPathMonitor: NWPathMonitor
    /// Объект мониторинга подключения к сети `Wi-Fi`.
    private let wifiNWPathMonitor: NWPathMonitor
    
    /// Очередь на которой работает объект мониторинга подключения к мобильной сети.
    private let cellularQueue: DispatchQueue
    /// Очередь на которой работает объект мониторинга подключения к сети `Wi-Fi`.
    private let wifiQueue: DispatchQueue
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    public init() {
        self.isReachableSubject = .init(false)
        self.stateSubject = .init(.unreachable)
        
        self.cellularQueue = DispatchQueue(
            label: "NWPathNetworkMonitor.cellularNWPathMonitor.queue",
            target: .global(qos: .utility)
        )
        self.wifiQueue = DispatchQueue(
            label: "NWPathNetworkMonitor.wifiNWPathMonitor.queue",
            target: .global(qos: .utility)
        )
        
        self.cellularNWPathMonitor = NWPathMonitor(requiredInterfaceType: .cellular)
        self.wifiNWPathMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
        
        self.setupPathUpdateHandlers()
    }
}

// MARK: - Network monitor protocol implementation

extension NWPathNetworkMonitor: NetworkMonitor {
    
    public func start() {
        cellularNWPathMonitor.start(queue: cellularQueue)
        wifiNWPathMonitor.start(queue: wifiQueue)
    }
    
    public func stop() {
        cellularNWPathMonitor.cancel()
        wifiNWPathMonitor.cancel()
    }
}

// MARK: - Network monitor setup functions

private extension NWPathNetworkMonitor {
    
    /// Выполняет настройку замыкания обратного вызова,
    /// сообщающего о статусе подключения к сети.
    func setupPathUpdateHandlers() {
        self.cellularNWPathMonitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isReachableSubject.send(true)
                self?.stateSubject.send(.reachable(withType: .cellular))
            }
            else if self?.wifiNWPathMonitor.currentPath.status != .satisfied {
                self?.isReachableSubject.send(false)
                self?.stateSubject.send(.unreachable)
            }
        }
        self.wifiNWPathMonitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isReachableSubject.send(true)
                self?.stateSubject.send(.reachable(withType: .wifi))
            }
            else if self?.cellularNWPathMonitor.currentPath.status != .satisfied {
                self?.isReachableSubject.send(false)
                self?.stateSubject.send(.unreachable)
            }
        }
    }
}
