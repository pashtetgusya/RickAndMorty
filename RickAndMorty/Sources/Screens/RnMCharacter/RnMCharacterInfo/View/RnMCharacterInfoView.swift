import UIKit

// MARK: - Rick and Morty character info view

/// Вью информации о персонаже из вселенной `"Rick and Morty"`.
final class RnMCharacterInfoView: BaseViewControllerView {
    
    // MARK: Subviews
    
    /// Таблица отображения информации о персонаже.
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.allowsMultipleSelection = false
        tableView.backgroundColor = .clear
        tableView.registerCell(ParameterCell.self)
        tableView.registerHeader(RnMCharacterInfoTableHeaderView.self)
        
        return tableView
    }()
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View setup functions

private extension RnMCharacterInfoView {
    
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
