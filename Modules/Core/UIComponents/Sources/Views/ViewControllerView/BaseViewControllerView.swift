import UIKit
import Resources

// MARK: - Base view controller view

/// Класс, реализующий базовое вью для вью контроллеров.
open class BaseViewControllerView: UIView {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    public init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - View setup functions

private extension BaseViewControllerView {
    
    /// Выполняет настройку `view`-компонентов.
    func setup() {
        backgroundColor = UIColor.viewDefaultBackgroundColor
    }
}
