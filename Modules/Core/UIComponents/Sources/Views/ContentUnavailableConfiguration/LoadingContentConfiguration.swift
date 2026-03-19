import UIKit

// MARK: - Loading UI content unavailable configuration

public extension UIContentUnavailableConfiguration {
    
    /// Создает конфигурацию отображения процесса загрузки.
    /// - Parameters:
    ///   - title: заголовок конфигурации.
    ///   - subtitle: подзаголовок конфигурации
    /// - Returns: конфигурация отображения процесса загрузки.
    static func loading(
        title: String,
        subtitle: String? = nil
    ) -> UIContentUnavailableConfiguration {
        var configuration = UIContentUnavailableConfiguration.loading()
        configuration.text = title
        configuration.secondaryText = subtitle
        
        return configuration
    }
}
