//
//  BaseTabbar.swift
//  ios-chips
//
//  Created by DU on 12/8/19.
//

import UIKit

class BaseTabbar: UITabBarController {
    
    // MARK: - Properties
    var currentTabbarType: TabbarType {
          return TabbarType(rawValue: self.tabBar.selectedItem?.tag ?? 0) ?? .home
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    // MARK: - Initialization Method
    private func customTabbar(visibleTabbar: TabbarType) {
        self.tabBar.barTintColor = AppColor.tabbarBackground
        self.tabBar.backgroundColor =  AppColor.tabbarBackground
        self.tabBar.tintColor = AppColor.tabbarBackground
        self.tabBar.isTranslucent = false
        
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.tabBar.layer.shadowOpacity = 0.2
        self.tabBar.layer.shadowRadius = 6
        
        self.tabBar.clipsToBounds = true
        
        let attributesNormal = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: AppColor.tabbarTitleNormal]
        let attributesSelect = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: AppColor.tabbarTitleSelected]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelect, for: .selected)
        
        swappedTabbar(tabbarSelected: visibleTabbar, initTime: true)
    }
    
    private func swappedTabbar(tabbarSelected: TabbarType, initTime: Bool) {
        for (tabbarIndex, tabbarType) in TabbarType.allCases.enumerated() {
            guard let tabbarItems = self.tabBar.items, tabbarItems.count > tabbarIndex else {
                return
            }
            let tabbarItem = tabbarItems[tabbarIndex]
            tabbarItem.title = (tabbarSelected == tabbarType) ? tabbarType.tabbarItems.title : ""
            if initTime {
                tabbarItem.image = UIImage(named: tabbarType.tabbarItems.image)?.withRenderingMode(.alwaysOriginal)
                tabbarItem.selectedImage = UIImage(named: tabbarType.tabbarItems.selectImage)?.withRenderingMode(.alwaysOriginal)
            }
            if (tabbarSelected == tabbarType) {
                tabbarItem.imageInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
                tabbarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: -5)
            }
            tabbarItem.tag = tabbarSelected.rawValue
        }
    }
    
    // MARK: - Public Method
    public func loadViewController() {
        var viewControllers: [UIViewController] = []
        for tabbarType in TabbarType.allCases {
            viewControllers.append(tabbarType.tabbarItems.rootViewController)
        }
        self.viewControllers = viewControllers
        
        self.customTabbar(visibleTabbar: .home)
    }
}

// MARK: - UITabBarControllerDelegate
extension BaseTabbar: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let tabbarSelected = TabbarType(rawValue: tabBarController.selectedIndex) {
            self.customTabbar(visibleTabbar: tabbarSelected)
            AnimatedBase.shared.animatedTabbar(tabbar: self.tabBar, tabbarIndex: tabBarController.selectedIndex, repeatCount: 1)
        }
    }
}

// MARK: - Execute tabbar
extension BaseTabbar {
    // Move to tab
    func moveToTab(tabbarType: TabbarType) {
        guard let tabbarItems = self.tabBar.items, tabbarItems.count > tabbarType.rawValue else {
            return
        }
        self.selectedIndex = tabbarType.rawValue
    }
    
    // Move to root view controller
    func moveToRootController(tabbarType: TabbarType) {
        guard let navigationController = self.getNavigationController(tabbarType: tabbarType) else { return }
        navigationController.popToRootViewController(animated: true)
    }
    
    // Get navigation controller of tabbar
    func getNavigationController(tabbarType: TabbarType) -> UINavigationController? {
        guard let viewControllers = self.viewControllers, viewControllers.count > tabbarType.rawValue else { return nil }
        guard let navigationController = viewControllers[tabbarType.rawValue] as? UINavigationController else { return nil }
        return navigationController
    }
}
