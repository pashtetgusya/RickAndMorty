import UIKit
import Combine
import Resources

// MARK: - Character info view controller

/// Вью контроллер информации о персонаже из вселенной `"Rick and Morty"`.
final class CharacterInfoViewController: UIViewController {
    
    // MARK: Properties
     
    private let contentView: CharacterInfoView
    private let dataSource: CharacterInfoTableViewDataSource
    private let viewModel: CharacterInfoViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init(viewModel: CharacterInfoViewModel) {
        self.contentView = CharacterInfoView()
        self.dataSource = CharacterInfoTableViewDataSource(for: self.contentView.tableView)
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}

// MARK: - Controller life cycle

extension CharacterInfoViewController {
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewModelBindings()
        
        viewModel.initialLoadCharacterInfo()
    }
}

// MARK: - UI table view delegate implementation

extension CharacterInfoViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        switch dataSource.sectionIdentifier(for: section) {
        case .details:
            let headerView: CharacterInfoTableViewHeaderView = tableView.dequeueHeader()
            let headerViewModel = viewModel.getCharacterInfoTableViewHeaderViewModel()
            headerView.setup(with: headerViewModel)
            
            return headerView
        
        default: return nil
        }
    }
    
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
}

// MARK: - Controller setup functions

private extension CharacterInfoViewController {
    
    /// Выпоняет настройку `view`-компонентов.
    func setupViews() {
        contentView.tableView.delegate = self
    }
    
    /// Выполняет настройку подписок на события вью модели.
    func setupViewModelBindings() {
        viewModel
            .$isLoading
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .map { $0 ? self.contentView.loadingConfiguration : nil }
            .assign(to: \.contentUnavailableConfiguration, on: self)
            .store(in: &cancellables)
        
        viewModel
            .$characterName
            .map { $0 }
            .assign(to: \.title, on: navigationItem)
            .store(in: &cancellables)
        
        viewModel
            .$characterInfoParameterList
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] parameterList in
                self?.dataSource.update(with: parameterList)
            }
            .store(in: &cancellables)
    }
}
