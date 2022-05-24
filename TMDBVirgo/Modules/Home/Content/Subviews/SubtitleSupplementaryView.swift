//
//  SubtitleSupplementaryView.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 23/05/22.
//

import UIKit

class SubtitleSupplementaryView: UICollectionReusableView {
    let label = UILabel()
    let button = UIButton(title: "See all reviews")
    static let reuseIdentifier = "subtitle-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension SubtitleSupplementaryView {
    func configure() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        
        addSubview(button)
        button.rightToSuperview(space: -inset)
        button.centerY(toView: label)
    }
}
