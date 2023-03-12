//
//  IconPagingCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 12/03/23.
//

import Parchment
import UIKit

struct IconPagingCellViewModel {
    let image: UIImage?
    let selected: Bool
    let tintColor: UIColor
    let selectedTintColor: UIColor

    init(image: UIImage?, selected: Bool, options: PagingOptions) {
        self.image = image
        self.selected = selected
        tintColor = options.textColor
        selectedTintColor = options.selectedTextColor
    }
}

class IconPagingCell: PagingCell {
    fileprivate var viewModel: IconPagingCellViewModel?

    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        setupConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        if let item = pagingItem as? IconItem {
            let viewModel = IconPagingCellViewModel(
                image: item.image,
                selected: selected,
                options: options
            )

            imageView.image = viewModel.image

            if viewModel.selected {
                imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                imageView.tintColor = viewModel.selectedTintColor
            } else {
                imageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                imageView.tintColor = viewModel.tintColor
            }

            self.viewModel = viewModel
        }
    }

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        guard let viewModel = viewModel else { return }
        if let attributes = layoutAttributes as? PagingCellLayoutAttributes {
            let scale = (0.4 * attributes.progress) + 0.6
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            imageView.tintColor = UIColor.interpolate(
                from: viewModel.tintColor,
                to: viewModel.selectedTintColor,
                with: attributes.progress
            )
        }
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let topContraint = NSLayoutConstraint(
            item: imageView,
            attribute: .top,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .top,
            multiplier: 1.0,
            constant: 15
        )

        let bottomConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: -15
        )

        let leadingContraint = NSLayoutConstraint(
            item: imageView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0
        )

        let trailingContraint = NSLayoutConstraint(
            item: imageView,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0
        )

        contentView.addConstraints([
            topContraint,
            bottomConstraint,
            leadingContraint,
            trailingContraint,
        ])
    }
}


extension UIColor {
    func components() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        guard let c = cgColor.components else { return (0, 0, 0, 1) }
        if cgColor.numberOfComponents == 2 {
            return (c[0], c[0], c[0], c[1])
        } else {
            return (c[0], c[1], c[2], c[3])
        }
    }

    static func interpolate(from: UIColor, to: UIColor, with fraction: CGFloat) -> UIColor {
        let f = min(1, max(0, fraction))
        let c1 = from.components()
        let c2 = to.components()
        let r = c1.0 + (c2.0 - c1.0) * f
        let g = c1.1 + (c2.1 - c1.1) * f
        let b = c1.2 + (c2.2 - c1.2) * f
        let a = c1.3 + (c2.3 - c1.3) * f
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
