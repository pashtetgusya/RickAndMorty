import UIKit

// MARK: - Application delegate

@main final class AppDelegate: UIResponder {
    
    // MARK: Properties
    
    var appDIContainer: AppDIContainer!
    var appCoordinator: AppCoordinator!
    
    var window: UIWindow?
}

// MARK: - UI application delegate implementation

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
    
    /// Создает и настраивает контейнер с зависимостями приложения.
    func setupDIcontainer() {
        appDIContainer = AppDIContainer()
        
        appDIContainer.register(NetworkMonitor.self) { _ in NWPathNetworkMonitor() }
        appDIContainer.register(RnMCharacterHTTPClient.self) { _ in RnMCharacterURLSessionHTTPClient() }
        appDIContainer.register(RnMEpisodeHTTPClient.self) { _ in RnMEpisodeURLSessionHTTPClient() }
        appDIContainer.register(ImageCache.self) { _ in NSImageCache() }
        appDIContainer.register(ImageLoader.self) { _ in URLSessionImageLoader() }
        appDIContainer.register(ImageProvider.self) { contaiter in
            DefaultImageProvider(
                imageLoader: contaiter.resolve(ImageLoader.self),
                imageCache: contaiter.resolve(ImageCache.self)
            )
        }
    }
    
    /// Создает и настраивает координатор приложения.
    func setupAppCoordinator() {
        appCoordinator = AppCoordinator(di: appDIContainer)
    }
    
    /// Создает и настраивает главный контроллер приложения.
    func setupRootViewControler() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator?.start()
        window?.makeKeyAndVisible()
    }
}
