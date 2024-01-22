//
//  ImageGalleryDIContainer.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/19/24.
//

import UIKit

final class ImageGalleryDIContainer {
    let viewController: ImageGalleryViewController

    init() {
        let imageGalleryService = ImageGalleryService()
        let imageLoader = ImageLoader()
        let router = ImageGalleryRouter()
        let dataStore = ImageGalleryDataSource(images: [])
        let viewModel = ImageGalleryViewModel(imageGalleryService: imageGalleryService,
                                              imageLoader: imageLoader,
                                              router: router,
                                              dataSource: dataStore)
        self.viewController = ImageGalleryViewController(viewModel: viewModel)
        router.viewController = viewController
    }
}
