import UIKit

// MARK: - Scene delegate

final class SceneDelegate: UIResponder {
    
    // MARK: Properties
    
    var window: UIWindow?
}

// MARK: - UI window scene delegate implementation

extension SceneDelegate: UIWindowSceneDelegate {
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let viewController = UIViewController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
