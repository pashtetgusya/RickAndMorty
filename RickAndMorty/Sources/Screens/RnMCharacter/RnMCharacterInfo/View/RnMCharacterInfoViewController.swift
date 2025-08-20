import UIKit
import Combine

// MARK: - Rick and Morty character info view controller

/// Вью контроллер информации о персонаже из вселенной `"Rick and Morty"`.
final class RnMCharacterInfoViewController: UIViewController {
    
    // MARK: Properties
     
    private let contentView: RnMCharacterInfoView
    private let dataSource: RnMCharacterInfoDataSource
    private let viewModel: RnMCharacterInfoViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init(viewModel: RnMCharacterInfoViewModel) {
        self.contentView = RnMCharacterInfoView()
        self.dataSource = RnMCharacterInfoDataSource(for: self.contentView.tableView)
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Controller life cycle

extension RnMCharacterInfoViewController {
    
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

extension RnMCharacterInfoViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        switch dataSource.sectionIdentifier(for: section) {
        case .details:
            let headerViewModel = viewModel.getCharacterInfoTableHeaderViewModel()
            let headerView: RnMCharacterInfoTableHeaderView = tableView.dequeueHeader()
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
            headerView.textLabel?.textColor = UIColor.textSub
        }
    }
}

// MARK: - Controller setup functions

private extension RnMCharacterInfoViewController {
    
    /// Выпоняет настройку `view`-компонентов.
    func setupViews() {
        contentView.tableView.delegate = self
    }
    
    /// Выполняет настройку подписок на события вью модели.
    func setupViewModelBindings() {
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
