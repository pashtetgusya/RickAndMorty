import UIKit
import Combine
import CombineCocoa
import Resources
import UIComponents

// MARK: - Character filter view controller

/// Вью контроллер списка фильтров для персонажей из вселенной `"Rick and Morty"`.
final class CharacterFilterViewController: UIViewController {
    
    // MARK: Properties
    
    private let contentView: CharacterFilterView
    private let dataSource: CharacterFilterTableViewDataSource
    private let viewModel: CharacterFilterViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init(viewModel: CharacterFilterViewModel) {
        self.contentView = CharacterFilterView()
        self.dataSource = CharacterFilterTableViewDataSource(for: contentView.tableView)
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Controller life cycle

extension CharacterFilterViewController {
    
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

// MARK: - UI table view delegate protocol implementation

extension CharacterFilterViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        // Переопределяем цвет текста хедера.
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.textSubColor
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
        case .gender: viewModel.setNewFilter(CharacterFilterTableViewModel.Section.Row.Gender.empty.erased)
        case .status: viewModel.setNewFilter(CharacterFilterTableViewModel.Section.Row.Status.empty.erased)
        
        default: break
        }
    }
}

// MARK: - Controller setup functions

private extension CharacterFilterViewController {
    
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
                
                if let indexPath = dataSource.indexPath(for: viewModel.currentFilter.gender.erased) {
                    contentView.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
                if let indexPath = dataSource.indexPath(for: viewModel.currentFilter.status.erased) {
                    contentView.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            }
            .store(in: &cancellables)
    }
}
