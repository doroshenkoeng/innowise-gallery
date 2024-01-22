//
//  ImageDetailViewController.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/20/24.
//

import UIKit
import Combine

final class ImageDetailViewController: UIViewController {
    private var scrollView: UIScrollView!

    private var activityIndicator: UIActivityIndicatorView!

    private var descriptionLabel: UILabel!

    private var barButtonItem: UIBarButtonItem!

    private var cancellableSet = Set<AnyCancellable>()

    private var viewModel: ImageDetailViewModel

    private var imageDetailViews = [ImageDetailView]()

    init(viewModel: ImageDetailViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()

        setupBindings()

        viewModel.loadImage()

        viewModel.loadIsFavoriteStatus()
    }

    private func setupBindings() {
        viewModel
            .$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self, let image else { return }

                let imageDetailView = currentImageDetailView

                let imageFactor = image.size.height / image.size.width

                let imageViewWidth = imageDetailView.imageView.bounds.width

                imageDetailView.imageViewHeightConstraint.constant = imageViewWidth * imageFactor
                imageDetailView.imageViewHeightConstraint.isActive = true

                imageDetailView.imageView.image = image
            }
            .store(in: &cancellableSet)

        viewModel
            .$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }

                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellableSet)

        viewModel
            .$description
            .receive(on: DispatchQueue.main)
            .sink { [weak self] description in
                guard let self else { return }

                let imageDetailView = currentImageDetailView

                imageDetailView.descriptionLabel.text = description
            }
            .store(in: &cancellableSet)

        viewModel
            .$isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in
                guard let self else { return }

                self.barButtonItem.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
            }
            .store(in: &cancellableSet)
    }

    @objc
    private func onFavoriteClick() {
        viewModel.onFavoriteClick()
    }

    private func configureViews() {
        self.view.backgroundColor = .white

        scrollView = UIScrollView()

        self.view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

        scrollView.isPagingEnabled = true

        scrollView.delegate = self

        let viewWidth = self.view.frame.width

        for index in 0..<viewModel.dataSource.images.count {
            let imageDetailView = ImageDetailView()

            imageDetailView.frame.origin = CGPoint(x: viewWidth * CGFloat(index), y: 0)

            imageDetailView.frame.size = self.view.frame.size

            imageDetailViews.append(imageDetailView)

            scrollView.addSubview(imageDetailView)
        }

        let scrollViewHeight = scrollView.bounds.height

        scrollView.contentSize = CGSize(width: CGFloat(imageDetailViews.count) * viewWidth, height: scrollViewHeight)

        scrollView.contentOffset = CGPoint(x: CGFloat(viewModel.selectedIndex) * viewWidth, y: 0)

        activityIndicator = UIActivityIndicatorView()

        self.view.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        barButtonItem = UIBarButtonItem()

        barButtonItem.image = UIImage(systemName: "heart")

        barButtonItem.action = #selector(onFavoriteClick)

        barButtonItem.target = self

        navigationItem.rightBarButtonItem = barButtonItem
    }

    private var currentImageDetailView: ImageDetailView {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)

        return imageDetailViews[index]
    }

}

extension ImageDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !viewModel.isLoading else { return }

        let index = Int(scrollView.contentOffset.x / self.view.bounds.width)

        viewModel.scrollViewDidScroll(to: index)
    }
}
