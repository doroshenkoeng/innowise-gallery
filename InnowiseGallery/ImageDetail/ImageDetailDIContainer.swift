//
//  ImageDetailDIContainer.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/22/24.
//

import Foundation

final class ImageDetailDIContainer {
    let viewController: ImageDetailViewController

    init(dataSource: ImageGalleryDataSource, selectedIndex: Int) {
        let imageLoader = ImageLoader()

        let viewModel = ImageDetailViewModel(
            dataSource: dataSource,
            selectedIndex: selectedIndex,
            imageLoader: imageLoader
        )

        self.viewController = ImageDetailViewController(viewModel: viewModel)
    }
}
