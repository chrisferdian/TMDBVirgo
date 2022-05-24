//
//  DetailCoordinator.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 21/05/22.
//

import Foundation
import UIKit

class DetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var item: HomeContentModel?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let detailController = DetailViewController()
        detailController.content = item
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(detailController, animated: true)
    }
}
