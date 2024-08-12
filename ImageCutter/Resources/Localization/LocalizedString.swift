//
//  LocalizedString.swift
//  ImageCutter
//
//  Created by Александра Среднева on 6.08.24.
//

import Foundation

enum LocalizedString {
    
    enum MainTabBar {
        static let settingsTitle = String(localized: "SettingsTabBarTitle.String")
        static let imageSelectorTitle = String(localized: "MainTabBarTitle.String")
    }
    
    enum Settings {
        static let cellTitleText = String(localized: "SettingsCellTitle.String")
        static let alertTitle = String(localized: "SettingsAlertTitle.String")
        static let alertMessage = String(localized: "SettingsAlertMessage.String")
        static let alertActionTitle = String(localized: "SettingsAlertActionTitle.String")
    }
    
    enum ImageSelector {
        static let saveButtonTitle = String(localized: "SaveButtonTitle.String")
        static let noFilterOption = String(localized: "NoFilterOption.String")
        static let grayScaleOption = String(localized: "GrayScaleOption.String")
        static let alertMe = String(localized: "GrayScaleOption.String")
        static let alertTitle = String(localized: "ImageSelectorAlertTitle.String")
        static let alertMessage = String(localized: "ImageSelectorAlertMessage.String")
        static let alertActionTitle = String(localized: "ImageSelectorAlertActionTitle.String")
    }
}
