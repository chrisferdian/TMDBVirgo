//
//  DetailViewController.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 21/05/22.
//

import UIKit
import Combine

class DetailViewController: UIViewController {

    var content: HomeContentModel?
    lazy private var collectionView = createCollectionView()
    lazy private var dataSource = self.configureDateSource()
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        self.title = content?.title
        setupCollectionView()
        self.collectionView.dataSource = self.dataSource
        self.dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            if section != .header {
                if section == .reviews {
                    let header: SubtitleSupplementaryView = collectionView.dequeue(footer: indexPath)
                    header.label.text = section.title
                    return header
                } else {
                    let header: TitleSupplementaryView = collectionView.dequeue(header: indexPath)
                    header.label.text = section.title
                    return header
                }
            }
            return UICollectionReusableView(background: .white)
        }
        if let id = self.content?.id {
            self.cancellable = APIManager().getReviews(type: "movie", id: id).sink { error in
                print(error)
            } receiveValue: { response in
                if let reviews = response.results, !reviews.isEmpty {
                    let reviewInfoList = reviews.map({ ReviewInfo(raw: $0) })
                    var snapshot = self.dataSource.snapshot()
                    snapshot.appendSections([.reviews])
                    snapshot.appendItems(reviewInfoList, toSection: .reviews)
                    self.dataSource.apply(snapshot)
                }
            }

        }
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.fillSuperView()
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DetailHeaderCollectionViewCell.self)
        collectionView.register(header: TitleSupplementaryView.self)
        collectionView.register(DetailVoteCollectionViewCell.self)
        collectionView.register(DetailLabelCollectionViewCell.self)
        collectionView.register(ReviewCollectionViewCell.self)
        collectionView.register(header: SubtitleSupplementaryView.self)
        collectionView.contentInset = .init(top: -100, left: 0, bottom: 0, right: 0)
        return collectionView
    }
    
    private func configureDateSource() -> DetailDataSource {
        let _dataSource = DetailDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .header:
                let cell: DetailHeaderCollectionViewCell = collectionView.dequeue(at: indexPath)
                if let url = itemIdentifier as? String {
                    cell.setImage(with: url)
                }
                return cell
            case .vote:
                let cell: DetailVoteCollectionViewCell = collectionView.dequeue(at: indexPath)
                if let avg = itemIdentifier as? Double {
                    cell.setupVote(with: avg)
                }
                return cell
            case .overview, .releaseDate:
                let cell: DetailLabelCollectionViewCell = collectionView.dequeue(at: indexPath)
                if let value = itemIdentifier as? String {
                    cell.setupData(section: section, valueText: value)
                }
                return cell
            case .reviews:
                let cell: ReviewCollectionViewCell = collectionView.dequeue(at: indexPath)
                if let value = itemIdentifier as? ReviewInfo {
                    cell.setupData(review: value)
                }
                return cell
            }
        }
        var snapshot = DetailSnapshot()
        snapshot.appendSections([.header, .vote, .overview, .releaseDate])
        snapshot.appendItems([self.content?.backdrop ?? self.content?.imageUrl], toSection: .header)
        snapshot.appendItems([self.content?.vote], toSection: .vote)
        snapshot.appendItems([self.content?.overview], toSection: .overview)
        snapshot.appendItems([self.content?.releaseDate], toSection: .releaseDate)
        _dataSource.apply(snapshot)
        return _dataSource
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
    }
    private func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let section = self.dataSource.snapshot().sectionIdentifiers[index]
        switch section {
        case .header:
            return createHeaderSection(environment: environment)
        case .vote:
            return createVoteSection()
        case .overview,
                .releaseDate:
            return createChildSection()
        case .reviews: return createChildSection(groupCount: 2)
        }
    }
    private func createVoteSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero//.init(top: 0, leading: 0, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    private func createChildSection(groupCount: Int = 1) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .estimated(44))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        var group: NSCollectionLayoutGroup
        if groupCount == 1 {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: groupCount)
        } else {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        }
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        ]
        return section
    }
    private func createHeaderSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(350))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero//.init(top: 0, leading: sideInset, bottom: 0, trailing: sideInset)

        let groupWidth = environment.container.contentSize.width //* 0.93
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth), heightDimension: .absolute(350))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        // add leading and trailing insets to the section so groups are aligned to the center
        let sectionSideInset = (environment.container.contentSize.width - groupWidth) / 2
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: sectionSideInset, bottom: 0, trailing: sectionSideInset)

        // note this is not .groupPagingCentered
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
}

class DetailHeaderCollectionViewCell: UICollectionViewCell {
    lazy private var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    private func setupView() {
        backgroundColor = .gray
        setupImageView()
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.fillSuperView()
    }
    func setImage(with url:String) {
        let url = "https://image.tmdb.org/t/p/" + "w780" + url
        self.imageView.downloadImage(from: url, placeholder: nil)
    }
}

class DetailVoteCollectionViewCell: UICollectionViewCell {
    lazy private var labelTitle = UILabel(font: .systemFont(ofSize: 14, weight: .medium), color: .black, numberOfLines: 1, alignment: .left)
    lazy private var dividerView = UIView(background: .black.withAlphaComponent(0.8))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    private func setupView() {
        backgroundColor = .white
        setupLabelTitle()
        setupDivider()
    }
    
    private func setupLabelTitle() {
        contentView.addSubview(labelTitle)
        labelTitle.verticalSuperview(space: 8)
        labelTitle.leftToSuperview(space: 16)
    }
    private func setupDivider() {
        contentView.addSubview(dividerView)
        dividerView.horizontalSuperview()
        dividerView.height(1)
        dividerView.bottomToSuperview()
    }
    func setupVote(with avg: Double) {
        let stringFormat = String(format: "Rating: %.1f", avg)
        self.labelTitle.text = stringFormat
    }
}

class DetailLabelCollectionViewCell: UICollectionViewCell {
    lazy private var labelDescription = UILabel(font: .systemFont(ofSize: 12, weight: .regular), color: .black, numberOfLines: 0, alignment: .left)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    private func setupView() {
        backgroundColor = .white
        setupLabelDescription()
    }
    
    private func setupLabelDescription() {
        contentView.addSubview(labelDescription)
        labelDescription.topToSuperview()
        labelDescription.horizontalSuperview(space: 16)
        labelDescription.bottomToSuperview(space: -4)
    }

    func setupData(section: DetailSection, valueText: String) {
        self.labelDescription.text = valueText
    }
}

class ReviewCollectionViewCell: UICollectionViewCell {
    lazy private var labelTitle = UILabel(font: .systemFont(ofSize: 16, weight: .medium), color: .black, numberOfLines: 1, alignment: .left)
    lazy private var labelDescription = UILabel(font: .systemFont(ofSize: 12, weight: .regular), color: .black, numberOfLines: 3, alignment: .left)
    lazy private var imageViewAvatar = UIImageView(background: .gray)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    //w45
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    private func setupView() {
        backgroundColor = .white
        setCorner(radius: 8)
        setBorder(width: 1, color: .gray)
        setupImageViewAvatar()
        setupLabelTitle()
        setupLabelDescription()
    }
    private func setupImageViewAvatar() {
        contentView.addSubview(imageViewAvatar)
        imageViewAvatar.size(width: 24, height: 24)
        imageViewAvatar.setCorner(radius: 12)
        imageViewAvatar.leftToSuperview(space: 16)
        imageViewAvatar.topToSuperview(space: 8)
    }
    private func setupLabelTitle() {
        contentView.addSubview(labelTitle)
        labelTitle.topToSuperview(space: 8)
        labelTitle.left(toAnchor: imageViewAvatar.rightAnchor, space: 8)
        labelTitle.rightToSuperview(space: -16)
    }
    
    private func setupLabelDescription() {
        contentView.addSubview(labelDescription)
        labelDescription.top(toAnchor: imageViewAvatar.bottomAnchor, space: 8)
        labelDescription.horizontalSuperview(space: 16)
        labelDescription.bottomToSuperview(space: -8)
    }

    func setupData(review: ReviewInfo) {
        self.labelTitle.text = review.authorName
        self.labelDescription.text = review.content
        let avatarUrl = "https://image.tmdb.org/t/p/" + "w45" + (review.authorAvatar ?? "")
        self.imageViewAvatar.downloadImage(from: avatarUrl, placeholder: nil)
    }
}
