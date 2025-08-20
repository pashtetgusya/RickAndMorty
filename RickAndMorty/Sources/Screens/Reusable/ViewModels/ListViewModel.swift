import Foundation
import Combine

// MARK: - List view model

/// Базовая вью модель экрана списка.
@MainActor class ListViewModel {
    
    // MARK: Properties
    
    /// Флаг ошибки загрузки страницы списка.
    @Published var isErrorLoading: Bool = false
    /// Флаг ошибки загрузки "следующей" страницы списка.
    var isErrorNextPageLoading: Bool = false
    /// Флаг выполнения начальной / повторной загрузки списка.
    @Published var isLoading: Bool = false
    /// Флаг выполнения обновления списка.
    @Published var isRefreshing: Bool = false
    /// Флаг выполнения загрузки "следующей" страницы списка.
    @Published var isNextPageLoading: Bool = false
    /// Флаг загрузки последней страницы.
    var isLastPageLoaded: Bool = false
    /// Текущая страница списка.
    var currentListPage: Int = 1
    
    /// Задача на загрузку следующей страницы списка.
    var loadNextListPageTask: Task<(), Never>? = nil
    /// Задача на повторную загрузку списка.
    var retryLoadListTask: Task<(), Never>? = nil
    
    var cancellables: Set<AnyCancellable> = []
}
