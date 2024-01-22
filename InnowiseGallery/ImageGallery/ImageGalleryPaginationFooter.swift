//
//  ImageGalleryPaginationFooter.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/20/24.
//

import UIKit

final class ImageGalleryPaginationFooter: UICollectionReusableView {
    static let reuseIdentifier = "\(ImageGalleryPaginationFooter.self)"

    private var activityIndicator: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        activityIndicator = UIActivityIndicatorView()

        self.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func start() {
        activityIndicator.startAnimating()
    }

    func stop() {
        activityIndicator.stopAnimating()
    }
}
