//
//  ImageGalleryViewController.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/17/24.
//

import UIKit
import Combine

final class ImageGalleryViewController: UIViewController {
    let viewModel: ImageGalleryViewModel

    private var collectionView: UICollectionView!

    private var activityIndicator: UIActivityIndicatorView!

    private var cancellableSet = Set<AnyCancellable>()

    init(viewModel: ImageGalleryViewModel) {
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

        fetchImageData()
    }

    private func configureViews() {
        activityIndicator = UIActivityIndicatorView(style: .large)

        self.view.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        configureCollectionView()
    }

    private func setupBindings() {
        viewModel
            .$images
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }

                self.collectionView.reloadData()

                self.activityIndicator.stopAnimating()
            }
            .store(in: &cancellableSet)

        viewModel
            .$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isRefreshing in
                guard let self else { return }

                guard let footer = self.collectionView.supplementaryView(
                    forElementKind: UICollectionView.elementKindSectionFooter,
                    at: .init(item: 0, section: 0)) as? ImageGalleryPaginationFooter else { return }

                if isRefreshing {
                    footer.start()
                } else {
                    footer.stop()
                }
            }
            .store(in: &cancellableSet)
    }

    private func fetchImageData() {
        viewModel.fetchImageData()
    }

    private func configureCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.minimumLineSpacing = 0

        flowLayout.minimumInteritemSpacing = 0

        flowLayout.footerReferenceSize = CGSize(width: self.view.bounds.width, height: 100)

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)

        self.view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true

        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

        collectionView.alwaysBounceVertical = true

        collectionView.dataSource = self

        collectionView.delegate = self

        collectionView.register(
            ImageGalleryCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageGalleryCollectionViewCell.reuseIdentifier
        )

        collectionView.register(
            ImageGalleryPaginationFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: ImageGalleryPaginationFooter.reuseIdentifier
        )
    }
}

extension ImageGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.images.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageGalleryCollectionViewCell.reuseIdentifier,
            for: indexPath) as? ImageGalleryCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.imageView.image = viewModel.images[indexPath.item]

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: ImageGalleryPaginationFooter.reuseIdentifier,
            for: indexPath) as? ImageGalleryPaginationFooter else {
            return UICollectionReusableView()
        }

        return footer
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectImage(at: indexPath)
    }
}

extension ImageGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = 4.0

        let cellWidth = collectionView.bounds.width / itemsPerRow

        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension ImageGalleryViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let heightOffset = collectionView.contentSize.height - collectionView.bounds.height + 100

        if collectionView.contentOffset.y > heightOffset, !viewModel.isLoading {
            fetchImageData()
        }
    }
}
