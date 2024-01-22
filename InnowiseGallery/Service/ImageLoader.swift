//
//  ImageLoader.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/19/24.
//

import Nuke
import UIKit

protocol ImageLoaderProtocol {
    func loadImages(galleryImages: [GalleryImage], with imageType: ImageType) async -> [UIImage]

    func loadImage(by urlString: String) async -> UIImage?
}

final class ImageLoader: ImageLoaderProtocol {
    func loadImages(galleryImages: [GalleryImage], with imageType: ImageType) async -> [UIImage] {
        await withTaskGroup(of: Optional<(Int, PlatformImage)>.self) { group in
            for (index, image) in galleryImages.enumerated() {
                group.addTask {
                    guard let loadedImage = await self.loadImage(by: image.getUrl(for: imageType)) else { return nil }

                    return (index, loadedImage)
                }
            }

            var images = [(Int, PlatformImage)]()

            for await image in group {
                guard let image else { continue }

                images.append(image)
            }

            return images.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }

    func loadImage(by urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }

        return try? await ImagePipeline.shared.image(for: url)
    }
}
