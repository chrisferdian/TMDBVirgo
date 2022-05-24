//
//  UIImageView+Extensions.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 20/05/22.
//

import SDWebImage
import UIKit

extension UIImageView {
    func downloadImage(from url: String?, placeholder: UIImage? = nil) {
        guard let url = url, let nsurl = URL(string: url) else {
            self.image = placeholder
            return
        }
        sd_setImage(with: nsurl, completed: nil)
    }
}
