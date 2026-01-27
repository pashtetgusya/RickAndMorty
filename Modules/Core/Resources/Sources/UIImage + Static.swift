import UIKit

// MARK: - UIImage static propertie

extension UIImage {
    
    public static let charactersTabBarItemActiveIcon = UIImage(named: "Characters_TabBarItem_Active_Icon") ?? UIImage()
    public static let charactersTabBarItemInactiveIcon = UIImage(named: "Characters_TabBarItem_Inactive_Icon") ?? UIImage()
    public static let episodesTabBarItemActiveIcon = UIImage(named: "Episodes_TabBarItem_Active_Icon") ?? UIImage()
    public static let episodesTabBarItemInactiveIcon = UIImage(named: "Episodes_TabBarItem_Inactive_Icon") ?? UIImage()
    public static let locationsTabBarItemActiveIcon = UIImage(named: "Locations_TabBarItem_Active_Icon") ?? UIImage()
    public static let locationsTabBarItemInactiveIcon = UIImage(named: "Locations_TabBarItem_Inactive_Icon") ?? UIImage()
    
    public static let checkBoxSelectedIcon = UIImage(named: "CheckBox_Selected_Icon") ?? UIImage()
    public static let checkBoxDeselectedIcon = UIImage(named: "CheckBox_Deselected_Icon") ?? UIImage()
    
    public static let charactersEmptySnapshot = UIImage(named: "Characters_EmptySnapshot") ?? UIImage()
    public static let charactersLoadError = UIImage(named: "Characters_LoadError") ?? UIImage()
    
    public static let characterInfoEpisodeIcon = UIImage(named: "CharacterInfo_Episode_Icon") ?? UIImage()
    public static let characterInfoGenderIcon = UIImage(named: "CharacterInfo_Gender_Icon") ?? UIImage()
    public static let characterInfoLastLocationIcon = UIImage(named: "CharacterInfo_LastLocation_Icon") ?? UIImage()
    public static let characterInfoOriginLocationIcon = UIImage(named: "CharacterInfo_OriginLocation_Icon") ?? UIImage()
    public static let characterInfoStatusIcon = UIImage(named: "CharacterInfo_Status_Icon") ?? UIImage()
}
