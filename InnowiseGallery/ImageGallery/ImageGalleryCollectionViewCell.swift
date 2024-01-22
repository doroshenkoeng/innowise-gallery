//
//  ImageGalleryCollectionViewCell.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/18/24.
//

import UIKit

final class ImageGalleryCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "\(ImageGalleryCollectionViewCell.self)"

    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView()

        self.contentView.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
