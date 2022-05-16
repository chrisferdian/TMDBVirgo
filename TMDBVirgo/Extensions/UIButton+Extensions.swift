//
//  UIButton+Extensions.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 16/05/22.
//

import UIKit

extension UIButton {
    func setBackground(color: UIColor, forState: UIControl.State) {
        let colorImage = imageFromColor(color: color)
        setBackgroundImage(colorImage, for: forState)
    }
    convenience init(title: String?,
                     titleColor: UIColor? = .black,
                     font: UIFont? = nil,
                     background: UIColor? = .clear,
                     cornerRadius: CGFloat = 0,
                     borderWidth: CGFloat = 0,
                     borderColor: UIColor = .clear) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)

        setTitleColor(titleColor, for: .normal)
        setTitleColor(titleColor?.withAlphaComponent(0.4), for: .disabled)
        if let _background = background {
            setBackground(color: _background, forState: .normal)
            setBackground(color: _background.withAlphaComponent(0.5), forState: .disabled)
        }

        titleLabel?.font = font
        setCorner(radius: cornerRadius)
        setBorder(width: borderWidth, color: borderColor)
    }
    
    private func imageFromColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
