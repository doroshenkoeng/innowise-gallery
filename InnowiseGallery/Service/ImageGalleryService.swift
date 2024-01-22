//
//  ImageGalleryService.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/19/24.
//

import Foundation

protocol ImageGalleryServiceProtocol {
    func fetchImageData(page: Int, perPage: Int) async -> [GalleryImage]
}

final class ImageGalleryService: ImageGalleryServiceProtocol {
    // Could be refactored to introduce a network manager that would handle interaction with URLSession
    // But for just one network request this implementation could be enough
    func fetchImageData(page: Int, perPage: Int) async -> [GalleryImage] {
        let urlString = "\(Config.serviceUrl)/photos?page=\(page)&per_page=\(perPage)"

        guard let url = URL(string: urlString) else { return [] }

        var urlRequest = URLRequest(url: url)

        urlRequest.setValue("Client-ID \(Config.apiKey)", forHTTPHeaderField: "Authorization")

        urlRequest.setValue("v1", forHTTPHeaderField: "Accept-Version")

        let responseData = try? await URLSession.shared.data(for: urlRequest)

        guard let responseData else { return [] }

        let (data, _) = responseData

        guard let galleryImages = try? JSONDecoder().decode([GalleryImage].self, from: data) else { return [] }

        return galleryImages
    }
}
