//
//  ViewController.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 16/05/22.
//

import UIKit
protocol SplashViewControllerDelegate: AnyObject {
    func navigateToMainScreen()
}
class SplashViewController: UIViewController {

    lazy var imageViewLogo = UIImageView(image: #imageLiteral(resourceName: "tmdb_blue_short"))
    weak var delegate: SplashViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupImageView()
        prepareToMainScreen()
    }

    private func setupImageView() {
        view.addSubview(imageViewLogo)
        imageViewLogo.translatesAutoresizingMaskIntoConstraints = false
        imageViewLogo.centerXToSuperview()
        imageViewLogo.centerYToSuperview()
    }
    
    private func prepareToMainScreen() {
        self.delegate?.navigateToMainScreen()
    }
}

class _DummMainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5647058824, green: 0.8078431373, blue: 0.631372549, alpha: 1)
    }
}
