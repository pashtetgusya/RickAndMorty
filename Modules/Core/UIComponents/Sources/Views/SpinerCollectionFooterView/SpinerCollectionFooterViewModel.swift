import Foundation
import Combine

// MARK: - Spiner collection footer view model

/// Вью модель футера коллекции с индикатором загрузки.
public final class SpinerCollectionFooterViewModel {
    
    // MARK: Properties
    
    /// Флаг выполнения процесса загрузки.
    @Published var isLoading: Bool
    /// Флаг наличиня подключения к сети.
    @Published var isNetworkReachable: Bool
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - isLoadingPublisher: паблишер флага процесса загрузки.
    ///   - isNetworkReachable: паблишер флага наличия подключения к сети.
    public init(
        isLoadingPublisher: AnyPublisher<Bool, Never>?,
        isNetworkReachablePublisher: AnyPublisher<Bool, Never>?
    ) {
        self.isLoading = false
        self.isNetworkReachable = false
        
        isLoadingPublisher?
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        isNetworkReachablePublisher?
            .assign(to: \.isNetworkReachable, on: self)
            .store(in: &cancellables)
    }
}
