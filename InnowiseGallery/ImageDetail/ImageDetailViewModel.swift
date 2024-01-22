//
//  ImageDetailViewModel.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/20/24.
//

import UIKit

final class ImageDetailViewModel {
    @Published var image: UIImage?

    @Published var isLoading = false

    @Published var description = ""

    @Published var isFavorite = false

    let dataSource: ImageGalleryDataSource

    var selectedIndex: Int

    private var selectedImage: GalleryImage {
        dataSource.images[selectedIndex]
    }

    private let imageLoader: ImageLoaderProtocol

    init(dataSource: ImageGalleryDataSource, selectedIndex: Int, imageLoader: ImageLoaderProtocol) {
        self.selectedIndex = selectedIndex
        self.dataSource = dataSource
        self.imageLoader = imageLoader
    }

    func loadImage() {
        Task {
            isLoading = true

            let dataSourceImage = dataSource.images[selectedIndex]

            let imageUrlString = dataSourceImage.fullUrl

            guard let image = await imageLoader.loadImage(by: imageUrlString) else { return }

            isLoading = false

            self.description = dataSourceImage.description.capitalizedFirstLetter

            self.image = image
        }
    }

    func loadIsFavoriteStatus() {
        Task {
            let favoriteImageIds = await ImageStorage.shared.imageIds

            self.isFavorite = favoriteImageIds.contains(selectedImage.id)
        }
    }

    func onFavoriteClick() {
        Task {
            if isFavorite {
                await ImageStorage.shared.removeImage(by: selectedImage.id)
            } else {
                await ImageStorage.shared.addImage(by: selectedImage.id)
            }

            isFavorite.toggle()
        }
    }

    func scrollViewDidScroll(to index: Int) {
        guard selectedIndex != index else { return }

        selectedIndex = index

        loadImage()
    }
}
