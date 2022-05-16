//
//  HomeViewController.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 16/05/22.
//

import Foundation
import UIKit

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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupStackTab()
        setupTabs()
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
            self.tabTVShow.isSelected = false
            self.tabMovie.isSelected = true
        }
        tabTVShow.action(.touchUpInside) { _ in
            self.tabTVShow.isSelected = true
            self.tabMovie.isSelected = false
        }
    }
}
