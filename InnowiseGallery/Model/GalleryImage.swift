//
//  GalleryImage.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/19/24.
//

import Foundation

struct GalleryImage {
    let id: String
    let description: String
    let thumbUrl: String
    let fullUrl: String
}

extension GalleryImage {
    enum CodingKeys: String, CodingKey {
        case id
        case description = "alt_description"
        case urls
    }

    enum UrlsCodingKeys: String, CodingKey {
        case thumb
        case full
    }
}

extension GalleryImage: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try values.decode(String.self, forKey: .id)

        self.description = try values.decode(String.self, forKey: .description)

        let urls = try values.nestedContainer(keyedBy: UrlsCodingKeys.self, forKey: .urls)

        self.thumbUrl = try urls.decode(String.self, forKey: .thumb)

        self.fullUrl = try urls.decode(String.self, forKey: .full)
    }
}

extension GalleryImage {
    func getUrl(for imageType: ImageType) -> String {
        switch imageType {
        case .thumb:
            thumbUrl
        case .full:
            fullUrl
        }
    }
}
