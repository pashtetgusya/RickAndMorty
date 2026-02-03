import UIKit
import UIComponents

// MARK: - Character info view

/// Вью информации о персонаже из вселенной `"Rick and Morty"`.
final class CharacterInfoView: BaseViewControllerView {
    
    // MARK: Subviews
    
    /// Таблица отображения информации о персонаже.
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.allowsMultipleSelection = false
        tableView.backgroundColor = .clear
        tableView.registerCell(ParameterTableViewCell.self)
        tableView.registerHeader(CharacterInfoTableViewHeaderView.self)
        
        return tableView
    }()
    
    // MARK: Properties
    
    /// Конфигурация отображения процесса загрузки контента.
    let loadingConfiguration: UIContentUnavailableConfiguration = {
        var configuration = UIContentUnavailableConfiguration.loading()
        configuration.text = "Please wait..."
        configuration.secondaryText = "Fetching character info."
        
        return configuration
    }()
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    override init() {
        super.init()
        
        addSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - View setup functions

private extension CharacterInfoView {
    
    /// Выполняет добавление `view`-компонентов.
    func addSubviews() {
        addSubview(tableView)
    }
    
    /// Выполняет настройку констрейнтов.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
