//
//  Resources.swift
//  ImageCutter
//
//  Created by Александра Среднева on 6.08.24.
//

import UIKit

enum Resources {
    
    enum Images {
        
        enum ImageSelector {
            case saveButtonImage
            case plusImage
            
            var image: UIImage? {
                switch self {
                case .saveButtonImage:
                    return UIImage(named: "saveImage")
                case .plusImage:
                    return UIImage(systemName: "plus")
                }
            }
        }
        
        enum MainTabBar {
            
            case imageSelectorTabBarIcon
            case settingsTapBarIcon
            
            var image: UIImage? {
                switch self {
                case .imageSelectorTabBarIcon:
                    return UIImage(systemName: "crop")
                case .settingsTapBarIcon:
                    return UIImage(systemName: "gearshape")
                }
            }
        }
    }
}
