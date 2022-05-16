//
//  AppCoordinator.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 16/05/22.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    unowned let navigationController:UINavigationController

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: SplashViewController = SplashViewController()
        viewController.delegate = self
        self.navigationController.viewControllers = [viewController]
    }
}

extension AppCoordinator: SplashViewControllerDelegate {
    func navigateToMainScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            let controller: _DummMainVC = _DummMainVC()
            self.navigationController.viewControllers = [controller]
        }
    }
}
