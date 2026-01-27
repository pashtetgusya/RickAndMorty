import UIKit

// MARK: - UIColor static properties

extension UIColor {
    
    public static let applicationTintColor = UIColor(named: "Application_TintColor") ?? UIColor.systemGray
    
    public static let navigationBarBackgroundColor = UIColor(named: "NavigationBar_BackgroundColor") ?? UIColor.systemGray
    
    public static let tabBarBackgroundColor = UIColor(named: "TabBar_BackgroundColor") ?? UIColor.systemGray
    public static let tabBarItemActiveColor = UIColor(named: "TabBar_Item_ActiveColor") ?? UIColor.systemGray
    public static let tabBarItemInactiveColor = UIColor(named: "TabBar_Item_InactiveColor") ?? UIColor.systemGray
    
    public static let textMainColor = UIColor(named: "Text_MainColor") ?? UIColor.systemGray
    public static let textSubColor = UIColor(named: "Text_SubColor") ?? UIColor.systemGray
    
    public static let viewDefaultBackgroundColor = UIColor(named: "View_Default_BackgroundColor") ?? UIColor.systemGray
}
