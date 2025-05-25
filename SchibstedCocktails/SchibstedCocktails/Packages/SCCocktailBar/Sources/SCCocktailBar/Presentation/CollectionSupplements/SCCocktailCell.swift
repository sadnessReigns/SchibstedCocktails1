//
//  SCCocktailCell.swift
//  SCCocktailBar
//
//  Created by Uladzislau Makei on 24.05.25.
//

import UIKit
import SCCommon

struct SCCocktailCellConfiguration: Equatable {
    static var initial: Self { .init(id: UUID().uuidString, title: "", imageURL: .init(string: "_")!) }

    let id: String
    let title: String
    let imageURL: URL
}

final class SCCocktailCell: UICollectionViewCell {

    static let reuseIdentifier: String = "SCCocktailCell"

    // MARK: - Configuration

    private var configuration: SCCocktailCellConfiguration = .initial {
        didSet {
            guard configuration != oldValue else { return }

            updateView()
        }
    }

    // MARK: - Subviews

    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.layer.masksToBounds = true
        iv.isAccessibilityElement = true
        iv.accessibilityTraits = .image

        return iv
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true


        return label
    }()

    // MARK: - Lifecycle

    override func prepareForReuse() {
        configuration = .initial
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            setupVisuals()
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupConstraints()
        setupVisuals()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup

private extension SCCocktailCell {

    func setupVisuals() {
        let (bgColor, titleColor) = switch traitCollection.userInterfaceStyle {
        case .dark:
            (
                UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1),
                UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
            )
        default:
            (
                UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1),
                UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
            )
        }
        contentView.backgroundColor = bgColor
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        titleLabel.textColor = titleColor
    }

    func setupHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }

    func setupConstraints() {
        setupImageViewConstraints()
        setupTitleLabelConstraints()
    }

    func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func setupTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func updateView() {
        titleLabel.text = configuration.title
        imageView.setImage(from: configuration.imageURL)

        imageView.accessibilityLabel = "Image of \(configuration.title)"
        accessibilityLabel = configuration.title
        accessibilityHint = "Tap to view \(configuration.title) details!"
        accessibilityTraits = .button // it's not a button now technically, but by the looks of it, it will be :)
        isAccessibilityElement = true
    }
}

// MARK: - Public API

extension SCCocktailCell {

    func configure(_ configuration: SCCocktailCellConfiguration) {
        self.configuration = configuration
    }
}
