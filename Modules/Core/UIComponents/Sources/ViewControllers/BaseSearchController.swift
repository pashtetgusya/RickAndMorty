import UIKit
import Resources

// MARK: - Base search controller

/// Класс, реализующий базовый контроллер поиска.
open class BaseSearchController: UISearchController, Sendable {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    public init() {
        super.init(searchResultsController: nil)
        
        setupSearchBar()
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Controller setup functions

private extension BaseSearchController {
    
    /// Выполняет настройку серч бара.
    func setupSearchBar() {
        obscuresBackgroundDuringPresentation = false
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = .done
        searchBar.tintColor = UIColor.applicationTintColor
    }
}
