import Foundation
import Combine

// MARK: - Spiner collection footer view model

/// Вью модель футера коллекции с индикатором загрузки.
@MainActor final class SpinerCollectionFooterViewModel {
    
    // MARK: Services
    
    private let networkMonitor: NetworkMonitor
    
    // MARK: Properties
    
    /// Флаг выполнения процесса загрузки.
    @Published var isLoading: Bool
    /// Флаг наличиня подключения к сети.
    @Published var isNetworkReachable: Bool
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter isLoadingPublisher: паблишер флага процесса загрузки.
    init(
        isLoadingPublisher: AnyPublisher<Bool, Never>,
        networkMonitor: NetworkMonitor
    ) {
        self.isLoading = false
        self.isNetworkReachable = true
        
        self.networkMonitor = networkMonitor
        
        isLoadingPublisher
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        networkMonitor
            .isReachablePublisher
            .dropFirst()
            .assign(to: \.isNetworkReachable, on: self)
            .store(in: &cancellables)
    }
}
