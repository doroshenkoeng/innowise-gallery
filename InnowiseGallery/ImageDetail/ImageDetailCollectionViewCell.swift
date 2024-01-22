//
//  ImageDetailCollectionViewCell.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/22/24.
//

import UIKit

final class ImageDetailView: UIView {
    var imageView: UIImageView!

    var activityIndicator: UIActivityIndicatorView!

    var descriptionLabel: UILabel!

    var imageViewHeightConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)

        activityIndicator = UIActivityIndicatorView()

        self.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        imageView = UIImageView()

        descriptionLabel = UILabel()

        imageView.contentMode = .scaleAspectFit

        self.addSubview(imageView)

        self.addSubview(descriptionLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true

        descriptionLabel.font = .preferredFont(forTextStyle: .title2)

        descriptionLabel.numberOfLines = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
