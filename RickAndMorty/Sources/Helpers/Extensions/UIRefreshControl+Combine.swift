import UIKit
import Combine
import CombineCocoa

// MARK: - UI refresh control combine publishers

extension UIRefreshControl {
    
    /// Паблишер, сообщающий о начале обновления.
    var beginRefreshingPublisher: AnyPublisher<Void, Never> {
        Publishers.ControlEvent(control: self, events: .valueChanged)
            .filter { [weak self] in self?.isRefreshing == true }
            .map { _ in}
            .eraseToAnyPublisher()
    }
}
