//
//  ImageGalleryRouter.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/21/24.
//

import Foundation

final class ImageGalleryDataSource {
    @Published var images: [GalleryImage]

    init(images: [GalleryImage]) {
        self.images = images
    }
}

final class ImageGalleryRouter {
    weak var viewController: ImageGalleryViewController?

    func navigateToImageDetail(with dataSource: ImageGalleryDataSource, selectedIndex: Int) {
        guard let dataSource = viewController?.viewModel.dataSource else { return }

        let imageDetailViewController = ImageDetailDIContainer(
            dataSource: dataSource,
            selectedIndex: selectedIndex
        ).viewController

        viewController?.navigationController?.pushViewController(imageDetailViewController, animated: true)
    }
}
