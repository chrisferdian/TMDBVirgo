//
//  HomeViewController.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 16/05/22.
//

import Foundation
import UIKit

protocol HomeViewDelegate: AnyObject {
    func didSelect(movie: HomeContentModel)
}

class HomeViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    lazy private var stackTab = UIStackView()
    lazy private var tabMovie = UIButton(
        title: "Movies",
        titleColor: .black,
        font: .systemFont(ofSize: 14, weight: .medium),
        background: #colorLiteral(red: 0.04984010011, green: 0.8574818969, blue: 0.9519322515, alpha: 1)
    )
    lazy private var tabTVShow = UIButton(
        title: "TV Shows",
        titleColor: .black,
        font: .systemFont(ofSize: 14, weight: .medium),
        background: #colorLiteral(red: 0.04984010011, green: 0.8574818969, blue: 0.9519322515, alpha: 1)
    )
    var delegate: HomeViewDelegate?
    var pageController = UIPageViewController(transitionStyle:
                                                UIPageViewController.TransitionStyle.scroll, navigationOrientation:
                                                UIPageViewController.NavigationOrientation.horizontal, options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupStackTab()
        setupTabs()
        setupPageController()
        configureControllers()
    }
    
    private func setupStackTab() {
        stackTab.translatesAutoresizingMaskIntoConstraints = false
        stackTab.addArrangedSubview(tabMovie)
        stackTab.addArrangedSubview(tabTVShow)
        self.view.addSubview(stackTab)
        stackTab.distribution = .fillEqually
        stackTab.topToSuperviewSafeArea()
        stackTab.horizontalSuperview()
        stackTab.height(44)
    }
    
    private func setupTabs() {
        [tabMovie, tabTVShow].forEach({
            $0.setBackground(color: #colorLiteral(red: 0.05098039216, green: 0.1450980392, blue: 0.2470588235, alpha: 1), forState: .selected)
            $0.setBackground(color: .white, forState: .normal)
            $0.setTitleColor(.white, for: .selected)
            $0.setTitleColor(.black, for: .normal)
        })
        tabMovie.action(.touchUpInside) { _ in
            if self.tabMovie.isSelected { return }
            self.tabTVShow.isSelected = false
            self.tabMovie.isSelected = true
            self.pageController.setViewControllers([self.orderedViewControllers[0]], direction: .reverse, animated: true, completion: nil)
        }
        tabTVShow.action(.touchUpInside) { _ in
            if self.tabTVShow.isSelected { return }
            self.tabTVShow.isSelected = true
            self.tabMovie.isSelected = false
            self.pageController.setViewControllers([self.orderedViewControllers[1]], direction: .forward, animated: true, completion: nil)
        }
        tabMovie.isSelected = true
    }
    
    private func setupPageController() {
        // Add this inside viewdidLoad
        pageController.dataSource = self
        pageController.delegate = self
        self.addChild(pageController)
        self.pageController.disableSwipeGesture()
        self.view.addSubview(pageController.view)
        self.pageController.view.translatesAutoresizingMaskIntoConstraints = false
        self.pageController.view.top(toAnchor: stackTab.bottomAnchor)
        self.pageController.view.horizontalSuperview()
        self.pageController.view.bottomToSuperview()
        self.pageController.didMove(toParent: self)
        self.pageController.setViewControllers([orderedViewControllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    private(set) lazy var orderedViewControllers: [HomeContentViewController] = {
        return [self.newContntViewController(type: .movies), self.newContntViewController(type: .tvShows)]
    }()
    
    
    private func newContntViewController(type: HomeContentType) -> HomeContentViewController {
        return HomeContentViewController(type: type)
    }
    
    private func configureControllers() {
        orderedViewControllers.forEach { _controller in
            _controller.delegate = self.delegate
        }
    }
}

extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = orderedViewControllers.firstIndex(of: viewController as! HomeContentViewController) {
                if index > 0 {
                    return orderedViewControllers[index - 1]
                } else {
                    return nil
                }
            }

            return nil
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            if let index = orderedViewControllers.firstIndex(of: viewController as! HomeContentViewController) {
                if index < orderedViewControllers.count - 1 {
                    return orderedViewControllers[index + 1]
                } else {
                    return nil
                }
            }
            return nil
        }
}
