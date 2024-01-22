//
//  ImageStorage.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/22/24.
//

import Foundation

enum ImageStorageError: Error {
    case urlIsNilOnReading
    case urlIsNilOnWriting
}

actor ImageStorage {
    var imageIds = Set<String>()

    static let shared = ImageStorage()

    private var favoriteImagesUrl: URL?

    private init() {
        guard let documentsDirectoryUrl = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { return }

        self.favoriteImagesUrl = documentsDirectoryUrl.appendingPathComponent("FavoriteImages")
    }

    func loadImageIds() {
        do {
            guard let favoriteImagesUrl else {
                throw ImageStorageError.urlIsNilOnReading
            }

            let data = try Data(contentsOf: favoriteImagesUrl)

            let imageIds = try JSONDecoder().decode(Set<String>.self, from: data)

            self.imageIds = imageIds
        } catch {
            print("Unable to get saved favorite images: \(error)")
        }
    }

    func saveFavoriteImages() {
        do {
            guard let favoriteImagesUrl else {
                throw ImageStorageError.urlIsNilOnWriting
            }

            let data = try JSONEncoder().encode(imageIds)

            try data.write(to: favoriteImagesUrl)

            self.favoriteImagesUrl = favoriteImagesUrl
        } catch {
            print("Unable to save data: \(error)")
        }
    }

    func removeImage(by id: String) {
        imageIds.remove(id)
    }

    func addImage(by id: String) {
        imageIds.insert(id)
    }
}
