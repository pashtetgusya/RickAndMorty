import UIKit
import DependencyInjection

// MARK: - Application delegate

@main final class AppDelegate: UIResponder {
    
    // MARK: Properties
    
    private(set) var appDIContainer: DIContainer?
}

// MARK: - UI application delegate protocol implementation

extension AppDelegate: UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupDIcontainer()
        
        return true
    }
}

// MARK: - Setup functions

private extension AppDelegate {
    
    /// Выполняет настройку контейнера с зависимостями приложения.
    func setupDIcontainer() {
        let diContainer = DIContainer()
        appDIContainer = diContainer
        
        let appDIAssembly = AppDIAssembly()
        appDIAssembly.assemble(in: diContainer)
    }
}
