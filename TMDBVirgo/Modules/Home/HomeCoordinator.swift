//
//  HomeCoordinator.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 16/05/22.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    var page: TabBarPage!
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = HomeViewController()
        controller.title = page.pageTitleValue()
        controller.tabBarItem.selectedImage = page.selectedIcon()
        self.navigationController.pushViewController(controller, animated: false)
    }
}
