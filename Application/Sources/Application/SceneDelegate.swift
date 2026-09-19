import UIKit
import UIComponents
import DependencyInjection
import Navigation

// MARK: - Scene delegate

final class SceneDelegate: UIResponder {
    
    // MARK: Properties
    
    private var appCoordinator: Coordinator?
    var window: UIWindow?
}

// MARK: - UI window scene delegate protocol implementation

extension SceneDelegate: UIWindowSceneDelegate {
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        setupAppCoordinator()
        setupRootViewControler(windowScene: windowScene)
    }
}

// MARK: - Support functions

private extension SceneDelegate {
    
    /// Выполняет настройку координатора приложения.
    func setupAppCoordinator() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let appDIContainer = appDelegate?.appDIContainer
        appCoordinator = appDIContainer?.resolve(
            AppCoordinator.self,
            args: BaseNavigationController()
        )
    }
    
    /// Выполняет настройку главного контроллера приложения.
    func setupRootViewControler(windowScene: UIWindowScene) {
        appCoordinator?.start()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = appCoordinator?.navController
        window?.makeKeyAndVisible()
    }
}
