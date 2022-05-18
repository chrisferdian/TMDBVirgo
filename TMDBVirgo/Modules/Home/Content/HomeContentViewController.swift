//
//  HomeContentViewController.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 18/05/22.
//

import Foundation
import UIKit

class HomeContentViewController: UIViewController {
    
    private var type: HomeContentType
    
    init(type: HomeContentType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("We don't using interface builder :(")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = type == .movies ? UIColor.green : UIColor.blue
    }
}
