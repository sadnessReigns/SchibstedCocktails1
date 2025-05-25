//
//  SCCocktailBarViewController.swift
//  SCCocktailBar
//
//  Created by Uladzislau Makei on 24.05.25.
//

import UIKit
import Combine

public final class SCCocktailBarViewController: UIViewController {

    // MARK: - Data

    private let viewModel: SCCocktailBarViewModel
    private var cocktailsUpdateCancellable: AnyCancellable?

    // MARK: - Subviews

    private lazy var dataSource: SCCocktailBarCollectionDataSource = {
        SCCocktailBarCollectionDataSource(collectionView: collectionView) { collectionView, indexPath, item in

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SCCocktailCell.reuseIdentifier,
                for: indexPath
            ) as? SCCocktailCell else {
                fatalError("Failed to dequeue a SCCocktailCell")
            }

            cell.configure(.init(id: item.id, title: item.title, imageURL: item.imageURL))

            return cell
        }
    }()

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let spacing: CGFloat = 12
        let itemsPerRow: CGFloat = 2
        let sectionInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = sectionInsets

        let totalSpacing = sectionInsets.left + sectionInsets.right + layout.minimumInteritemSpacing
        let itemWidth = (view.bounds.width - totalSpacing) / itemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)

        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collection.allowsSelection = false
        collection.backgroundColor = .clear
        return collection
    }()

    private let feedbackGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.backgroundColor = .clear
        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return control
    }()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        title = "Cocktail Bar"
        feedbackGenerator.prepare()
        setupCollectionView()
        setupHierarchy()
        setupConstraints()
        setupDataFlow()
        performInitialLoad()
        setupVisuals()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            setupVisuals()
        }
    }

    // MARK: - Init

    public init(viewModel: SCCocktailBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Misc

private extension SCCocktailBarViewController {

    func performInitialLoad() {
        Task { [weak viewModel] in
            guard let viewModel else { return }
            await viewModel.loadCocktails()
        }
    }

    func setupDataFlow() {
        cocktailsUpdateCancellable = viewModel.$cocktails.sink { @MainActor [weak self] items in
            guard let self else { return }

            var snapshot = NSDiffableDataSourceSnapshot<SCCocktailBarSection, SCCocktailItem>()
            snapshot.appendSections([.main])
            snapshot.appendItems(items, toSection: .main)

            self.dataSource.apply(snapshot, animatingDifferences: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
                    guard let self else { return }

                    self.refreshControl.endRefreshing()

                    self.feedbackGenerator.impactOccurred(intensity: 0.65)
                    self.feedbackGenerator.prepare()
                }
            }
        }
    }

    @objc func handleRefresh() {
        DispatchQueue.main.async { [weak feedbackGenerator] in
            guard let feedbackGenerator else { return }

            feedbackGenerator.impactOccurred(intensity: 0.8)
            feedbackGenerator.prepare()
        }
        Task { [weak viewModel] in
            await viewModel?.loadCocktails()
        }
    }

    func setupCollectionView() {
        collectionView.register(SCCocktailCell.self, forCellWithReuseIdentifier: SCCocktailCell.reuseIdentifier)
        collectionView.refreshControl = refreshControl
    }
}

// MARK: - UI Setup

private extension SCCocktailBarViewController {

    func setupVisuals() {
        view.backgroundColor = switch traitCollection.userInterfaceStyle {
        case .dark: UIColor(red: 15/255, green: 15/255, blue: 15/255, alpha: 1)
        default: UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        }
    }

    func setupHierarchy() {
        view.addSubview(collectionView)
        setupCollectionViewConstraints()
    }

    func setupConstraints() {
        setupCollectionViewConstraints()
    }

    func setupCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
