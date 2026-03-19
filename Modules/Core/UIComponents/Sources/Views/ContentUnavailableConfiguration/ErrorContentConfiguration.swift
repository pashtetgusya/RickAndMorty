import UIKit

// MARK: - Error UI content unavailable configuration

public extension UIContentUnavailableConfiguration {
    
    /// Создает конфигурацию отображения ошибки.
    /// - Parameters:
    ///   - title: заголовок конфигурации.
    ///   - subtitle: подзаголовок конфигурации.
    ///   - icon: иконка конфигурации.
    ///   - retryAction: экшн нажатия кнопки "Повторить".
    /// - Returns: кофигурация отображения ошибки загрузки.
    static func error(
        title: String,
        subtitle: String? = nil,
        icon: UIImage? = nil,
        retryAction: UIAction? = nil
    ) -> UIContentUnavailableConfiguration {
        var buttonConfiguration = UIButton.Configuration.borderless()
        buttonConfiguration.title = "Retry"
        buttonConfiguration.image = UIImage(systemName: "arrow.clockwise")
        buttonConfiguration.baseForegroundColor = UIColor.applicationTintColor
        
        var configuration = UIContentUnavailableConfiguration.empty()
        configuration.image = icon
        configuration.text = title
        configuration.secondaryText = subtitle
        configuration.button = buttonConfiguration
        configuration.buttonProperties.primaryAction = retryAction
        
        return configuration
    }
}
