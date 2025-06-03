import UIKit

// MARK: - Base search controller

/// Класс, реализующий базовый контроллер поиска.
class BaseSearchController: UISearchController {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init() {
        super.init(searchResultsController: nil)
        
        setupSearchBar()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Controller setup functions

private extension BaseSearchController {
    
    /// Настраивает серч бар.
    func setupSearchBar() {
        obscuresBackgroundDuringPresentation = false
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = .done
        searchBar.tintColor = UIColor.applicationTint
    }
}
