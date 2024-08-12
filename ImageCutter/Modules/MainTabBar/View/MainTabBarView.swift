//
//  MainTabBarView.swift
//  ImageCutter
//
//  Created by Александра Среднева on 6.08.24.
//

import UIKit

class MainTabBarView: UITabBarController {

    enum NavigationOptions: CaseIterable {
        case imageSelector
        case settings
        
        var title: String {
            switch self {
            case .imageSelector:
                return LocalizedString.MainTabBar.imageSelectorTitle
            case .settings:
                return LocalizedString.MainTabBar.settingsTitle
            }
        }
        
        var image: UIImage? {
            switch self {
            case .imageSelector:
                return Resources.Images.MainTabBar.imageSelectorTabBarIcon.image
            case .settings:
                return Resources.Images.MainTabBar.settingsTapBarIcon.image
            }
        }
    }
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
        setupTabBar()
    }
    
    // MARK: - Private Methods
    
    private func setupTabBarItems() {
        viewControllers = NavigationOptions.allCases.map { [weak self] tabItem in
            guard let self else {
                return UIViewController()
            }
            return self.createViewController(for: tabItem)
        }
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .blue
        tabBar.backgroundColor = .white
    }
    
    private func setUpTabBarItem(
        for viewController: UIViewController,
        with tabOption: NavigationOptions
    ) {
        viewController.tabBarItem.title = tabOption.title
        viewController.tabBarItem.image = tabOption.image
        viewController.title = title
    }
    
    private func createViewController(for tab: NavigationOptions) -> UIViewController {
        switch tab {
        case .imageSelector:
            let imageSelectorViewController = ImageSelectorViewController()
            setUpTabBarItem(
                for: imageSelectorViewController,
                with: .imageSelector
            )
            return imageSelectorViewController
        case .settings:
            let settingsViewController = SettingsViewController()
            setUpTabBarItem(
                for: settingsViewController,
                with: .settings
            )
            return settingsViewController
        }
    }
}
