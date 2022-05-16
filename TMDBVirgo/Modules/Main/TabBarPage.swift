//
//  TabBar.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 16/05/22.
//

import Foundation
import UIKit
enum TabBarPage {
    case home
    case account

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .account
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "Home"
        case .account:
            return "Account"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .account:
            return 1
        }
    }
    
    func unselectedIcon() -> UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house.circle")
        case .account:
            return UIImage(systemName: "person.circle")
        }
    }
    
    func selectedIcon() -> UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house.circle.fill")
        case .account:
            return UIImage(systemName: "person.circle.fill")
        }
    }
}
