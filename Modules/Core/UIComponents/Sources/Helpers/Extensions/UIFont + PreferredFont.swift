import UIKit

// MARK: - Preferred font functions

public extension UIFont {
    
    /// Выполняет получение шрифта для указанного стиля с фиксированным размером.
    /// - Parameters:
    ///   - textStyle: стиль текста шрифта.
    ///   - sizeCategory: категория размера шрифта (по умолчанию `large`).
    /// - Returns: шрифт с фиксированным размером.
    static func preferredFontFixed(
        forTextStyle textStyle: UIFont.TextStyle,
        sizeCategory: UIContentSizeCategory = .large
    ) -> UIFont {
        let traitCollection = UITraitCollection(preferredContentSizeCategory: sizeCategory)
        let font = UIFont.preferredFont(forTextStyle: textStyle, compatibleWith: traitCollection)
        
        return font
    }
}
