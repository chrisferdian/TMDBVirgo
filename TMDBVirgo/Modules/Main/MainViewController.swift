//
//  MainViewController.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 16/05/22.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }
}
