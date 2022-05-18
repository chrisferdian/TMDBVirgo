//
//  UIPageViewController+Extensions.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 17/05/22.
//

import UIKit

extension UIPageViewController {

    func enableSwipeGesture() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = true
            }
        }
    }

    func disableSwipeGesture() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
}

