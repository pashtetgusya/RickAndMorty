import UIKit

// MARK: - Rick and Morty character filter view

/// Вью списка фильтров для персонажей из вселенной `"Rick and Morty"`.
final class RnMCharacterFilterView: BaseViewControllerView {
    
    // MARK: Subviews
    
    /// Айтем приминения фильтра.
    let applyFilterItem: UIBarButtonItem = {
        UIBarButtonItem(title: "Apply")
    }()
    /// Айтмем отмены.
    let cancelItem: UIBarButtonItem = {
        UIBarButtonItem(title: "Cancel")
    }()
    /// Таблица отображения списка фильтров для персонажей.
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        tableView.backgroundColor = .clear
        tableView.registerCell(FilterCell.self)
        
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

private extension RnMCharacterFilterView {
    
    /// Добавляет сабвью.
    func addSubviews() {
        addSubview(tableView)
    }
    
    /// Настраивает констрейнты.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
