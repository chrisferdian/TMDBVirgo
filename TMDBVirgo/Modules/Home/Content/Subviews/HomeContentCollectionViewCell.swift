//
//  HeaderCollectionViewCell.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 20/05/22.
//
import UIKit

class HomeContentCollectionViewCell: UICollectionViewCell {
    lazy private var imageView = UIImageView()
    lazy private var labelTitle = UILabel(font: .systemFont(ofSize: 14, weight: .medium), color: .white, numberOfLines: 1, alignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    private func setupView() {
        backgroundColor = .gray
        setCorner(radius: 8)
        setupImageView()
        setupLabelTitle()
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.fillSuperView()
    }
    
    private func setupLabelTitle() {
        contentView.addSubview(labelTitle)
        labelTitle.backgroundColor = .black.withAlphaComponent(0.8)
        labelTitle.bottomToSuperview()
        labelTitle.horizontalSuperview()
        labelTitle.height(44)
    }
    
    func setData(with content: HomeContentModel, section: ContentSection) {
        let size = section == .header ? "w780/" : "w342/"
        let url = "https://image.tmdb.org/t/p/" + size + (content.imageUrl ?? "")
        self.imageView.downloadImage(from: url, placeholder: nil)
        labelTitle.isHidden = section != .header
        self.labelTitle.text = content.title
    }
}
