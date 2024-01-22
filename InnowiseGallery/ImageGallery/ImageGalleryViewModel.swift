//
//  ImageGalleryViewModel.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/19/24.
//

import Nuke
import UIKit

final class ImageGalleryViewModel: ObservableObject {
    @Published var images = [UIImage]()

    @Published var isLoading = false

    let dataSource: ImageGalleryDataSource

    private var page = 1

    private let imageGalleryService: ImageGalleryServiceProtocol

    private let imageLoader: ImageLoaderProtocol

    private let router: ImageGalleryRouter

    init(
        imageGalleryService: ImageGalleryServiceProtocol,
        imageLoader: ImageLoaderProtocol,
        router: ImageGalleryRouter,
        dataSource: ImageGalleryDataSource
    ) {
        self.imageGalleryService = imageGalleryService
        self.imageLoader = imageLoader
        self.router = router
        self.dataSource = dataSource
    }

    func fetchImageData() {
        Task {
            isLoading = true

            let galleryImages = await self.imageGalleryService.fetchImageData(page: page, perPage: 30)

            dataSource.images.append(contentsOf: galleryImages)

            let loadedImages = await self.imageLoader.loadImages(galleryImages: galleryImages, with: .thumb)

            isLoading = false

            self.images.append(contentsOf: loadedImages)

            page += 1
        }
    }

    func didSelectImage(at indexPath: IndexPath) {
        router.navigateToImageDetail(with: dataSource, selectedIndex: indexPath.item)
    }
}
