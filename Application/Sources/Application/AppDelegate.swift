import UIKit

// MARK: - Application delegate

@main final class AppDelegate: UIResponder {
    
    // MARK: Properties
    
    private var appDIContainer: AppDIContainer!
    private var appCoordinator: AppCoordinator!
    
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
        appCoordinator = AppCoordinator(di: appDIContainer)
    }
    
    /// Выполняет настройку главного контроллера приложения.
    func setupRootViewControler() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator?.start()
        window?.makeKeyAndVisible()
    }
}
