//
//  Coordinator.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 16/05/22.
//

import UIKit

public protocol Coordinator : AnyObject {
    var childCoordinators: [Coordinator] { get set }
    init(navigationController:UINavigationController)
    func start()
}
