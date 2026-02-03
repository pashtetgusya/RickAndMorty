import UIKit
import UIComponents
import Navigation
import DependencyInjection

// MARK: - Application delegate

@main final class AppDelegate: UIResponder {
    
    // MARK: Properties
    
    private var appDIContainer: DIContainer!
    private var appCoordinator: Coordinator!
    
    var window: UIWindow?
}

// MARK: - UI application delegate protocol implementation

extension AppDelegate: UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupDIcontainer()
        setupAppCoordinator()
        setupRootViewControler()
        
        return true
    }
}

// MARK: - Setup functions

private extension AppDelegate {
    
    /// Выполняет настройку контейнера с зависимостями приложения.
    func setupDIcontainer() {
        appDIContainer = AppDIContainer()
        
        let appDIAssembly = AppDIAssembly()
        appDIAssembly.assemble(in: appDIContainer)
    }
    
    /// Выполняет настройку координатора приложения.
    func setupAppCoordinator() {
        let navController = BaseNavigationController()
        appCoordinator = AppCoordinator(di: appDIContainer, navController: navController)
    }
    
    /// Выполняет настройку главного контроллера приложения.
    func setupRootViewControler() {
        appCoordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator.navController
        window?.makeKeyAndVisible()
    }
}
