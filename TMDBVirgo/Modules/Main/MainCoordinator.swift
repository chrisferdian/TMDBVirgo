//
//  MainCoordinator.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 16/05/22.
//

import UIKit

protocol MainCoordinatorDelegate: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
}
class MainCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController: MainViewController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        tabBarController = .init()
    }
    
    func start() {
        let pages: [TabBarPage] = [.home, .account]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        prepareTabBarController(withTabControllers: controllers)
    }
    deinit {
        print("TabCoordinator deinit")
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        /// Set delegate for UITabBarController
        tabBarController.delegate = self
        /// Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: true)
        /// Let set index
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        /// Styling
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .white
        /// In this step, we attach tabBarController to navigation controller associated with this coordanator
        if let scene = UIApplication.shared.connectedScenes.first {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            windowScene.windows.first?.rootViewController = tabBarController
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        
        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: page.unselectedIcon(),
                                                     tag: page.pageOrderNumber())
        switch page {
        case .home:
            let homeVC = HomeViewController()
            homeVC.title = page.pageTitleValue()
            homeVC.tabBarItem.selectedImage = page.selectedIcon()
            navController.pushViewController(homeVC, animated: true)
        case .account:
            let accountVC = AccountViewController()
            accountVC.title = page.pageTitleValue()
            accountVC.tabBarItem.selectedImage = page.selectedIcon()
            navController.pushViewController(accountVC, animated: true)
        }
        return navController
    }
    
    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
}

extension MainCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        // Some implementation
    }
}
