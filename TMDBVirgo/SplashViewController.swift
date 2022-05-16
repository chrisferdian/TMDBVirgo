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

    lazy private var labelGuest = UILabel(
        text: "Guest",
        font: .systemFont(ofSize: 14, weight: .regular),
        color: .black,
        numberOfLines: 1,
        alignment: .center
    )
    lazy var imageViewLogo = UIImageView(image: #imageLiteral(resourceName: "tmdb_blue_short"))
    weak var delegate: SplashViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupImageView()
        setupLabelGuest()
        prepareToMainScreen()
    }

    private func setupImageView() {
        view.addSubview(imageViewLogo)
        imageViewLogo.translatesAutoresizingMaskIntoConstraints = false
        imageViewLogo.centerXToSuperview()
        imageViewLogo.centerYToSuperview()
    }
    
    private func setupLabelGuest() {
        view.addSubview(labelGuest)
        labelGuest.top(toAnchor: imageViewLogo.bottomAnchor, space: 64)
        labelGuest.centerXToSuperview()
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
