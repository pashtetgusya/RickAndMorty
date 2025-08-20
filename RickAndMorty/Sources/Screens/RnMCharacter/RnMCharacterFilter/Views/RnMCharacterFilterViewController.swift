import UIKit
import Combine
import CombineCocoa

// MARK: - Rick and morty character filter view controller

/// Вью контроллер списка фильтров для персонажей из вселенной `"Rick and Morty"`.
final class RnMCharacterFilterViewController: UIViewController {
    
    // MARK: Properties
    
    private let contentView: RnMCharacterFilterView
    private let dataSource: RnMCharacterFilterDataSource
    private let viewModel: RnMCharacterFilterViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init(viewModel: RnMCharacterFilterViewModel) {
        self.contentView = RnMCharacterFilterView()
        self.dataSource = RnMCharacterFilterDataSource(for: contentView.tableView)
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Controller life cycle

extension RnMCharacterFilterViewController {
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewBindings()
        setupViewModelBindings()
    }
}

// MARK: - UI table view delegate implementation

extension RnMCharacterFilterViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        // Переопределяем цвет текста хедера.
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.textSub
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let selectedRows = tableView.indexPathsForSelectedRows?.filter {
            $0.section == indexPath.section && $0.row != indexPath.row
        }
        selectedRows?.forEach { tableView.deselectRow(at: $0, animated: true) }
        
        guard
            let filter = dataSource.itemIdentifier(for: indexPath)
        else { return }
        
        viewModel.setNewFilter(filter)
    }
    
    func tableView(
        _ tableView: UITableView,
        didDeselectRowAt indexPath: IndexPath
    ) {
        switch dataSource.sectionIdentifier(for: indexPath.section) {
        case .gender: viewModel.setNewFilter(RnMCharacterFilterModel.CharacterGenderFilter.empty.erased())
        case .status: viewModel.setNewFilter(RnMCharacterFilterModel.CharacterStatusFilter.empty.erased())
        
        default: break
        }
    }
}

// MARK: - Controller setup functions

private extension RnMCharacterFilterViewController {
    
    /// Выпоняет настройку `view`-компонентов.
    func setupViews() {
        contentView.tableView.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.leftBarButtonItem = contentView.cancelItem
        navigationItem.rightBarButtonItem = contentView.applyFilterItem
        navigationItem.title = "Filter"
    }
    
    /// Выполняет настройку подписок на события вью.
    func setupViewBindings() {
        contentView
            .applyFilterItem
            .tapPublisher
            .sink { [weak self] in
                self?.viewModel.applyFilter()
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
        
        contentView
            .cancelItem
            .tapPublisher
            .sink { [weak self] in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
    
    /// Выполняет настройку подписок на события вью модели.
    func setupViewModelBindings() {
        viewModel
            .hasChangesPublisher
            .assign(to: \.isEnabled, on: contentView.applyFilterItem)
            .store(in: &cancellables)
        
        viewModel
            .$filterList
            .sink { [weak self] filterList in
                guard let self else { return }
                
                dataSource.update(with: filterList)
                
                if let indexPath = dataSource.indexPath(for: viewModel.currentFilter.gender.erased()) {
                    contentView.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
                if let indexPath = dataSource.indexPath(for: viewModel.currentFilter.status.erased()) {
                    contentView.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            }
            .store(in: &cancellables)
    }
}
