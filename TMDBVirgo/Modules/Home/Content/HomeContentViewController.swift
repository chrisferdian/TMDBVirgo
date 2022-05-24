//
//  HomeContentViewController.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 18/05/22.
//

import Foundation
import UIKit

protocol HomeControllerDelegate: AnyObject {
    func didSelect(movie: HomeContentModel)
}
class HomeContentViewController: UIViewController {
    
    var delegate: HomeViewDelegate?
    private var type: HomeContentType
    lazy private var collectionView = createCollectionView()
    lazy private var dataSource = self.configureDateSource()
    private let viewModel = HomeContentViewModel()
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
        setupCollectionView()
        self.collectionView.dataSource = self.dataSource
        self.dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            if section != .header {
                let header: TitleSupplementaryView = collectionView.dequeue(header: indexPath)
                header.label.text = section.sectionTitle
                return header
            }
            return UICollectionReusableView(background: .clear)
        }
        viewModel.delegate = self
        if type == .movies {
            viewModel.fetchNowPlaying()
            viewModel.fetchTrending(type: "movie")
            viewModel.fetchDiscover(type: "movie")
        } else {
            viewModel.fetchTvOnAir()
            viewModel.fetchTrending(type: "tv")
            viewModel.fetchDiscover(type: "tv")
        }
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.fillSuperviewSafeArea()
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HomeContentCollectionViewCell.self)
        collectionView.register(header: TitleSupplementaryView.self)
        collectionView.delegate = self
        return collectionView
    }
    
    private func configureDateSource() -> ContentDataSource {
        let _dataSource = ContentDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let cell: HomeContentCollectionViewCell = collectionView.dequeue(at: indexPath)
            if let content = itemIdentifier as? HomeContentModel {
                cell.setData(with: content, section: section)
            }
            return cell
        }
        var snapshot = ContentSnapshot()
        snapshot.appendSections([.header, .trending, .discover])
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
        case .trending:
            return createChildSection()
        case .discover:
            return createChildSection()
        }
    }
    private func createChildSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(2))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        ]

        return section
    }
    private func createHeaderSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let sideInset: CGFloat = 5

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: sideInset, bottom: 0, trailing: sideInset)

        let groupWidth = environment.container.contentSize.width * 0.93
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth), heightDimension: .absolute(300))
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
extension HomeContentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = self.dataSource.snapshot()
        let section = snapshot.sectionIdentifiers[indexPath.section]
        if let item = snapshot.itemIdentifiers(inSection: section)[indexPath.row] as? HomeContentModel {
            self.delegate?.didSelect(movie: item)
        }
    }
}
extension HomeContentViewController: HomeContentDelegate {
    func didReceive(populars: [HomeContentModel]) {
        if !populars.isEmpty {
            DispatchQueue.main.async {
                var snapshot = self.dataSource.snapshot()
                snapshot.appendItems(populars, toSection: .trending)
                self.dataSource.apply(snapshot)
            }
        }
    }
    
    func didReceive(discover: [HomeContentModel]) {
        if !discover.isEmpty {
            DispatchQueue.main.async {
                var snapshot = self.dataSource.snapshot()
                snapshot.appendItems(discover, toSection: .discover)
                self.dataSource.apply(snapshot)
            }
        }
    }
    
    func didReceive(playing: [HomeContentModel]) {
        if !playing.isEmpty {
            DispatchQueue.main.async {
                var snapshot = self.dataSource.snapshot()
                snapshot.appendItems(playing, toSection: .header)
                self.dataSource.apply(snapshot)
            }
        }
    }
}
