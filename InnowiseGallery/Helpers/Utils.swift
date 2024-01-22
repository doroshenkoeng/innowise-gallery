//
//  Utils.swift
//  InnowiseGallery
//
//  Created by Siarhei Darashenka on 1/22/24.
//

import Foundation

extension String {
    var capitalizedFirstLetter: String {
        let stringArray = Array(self)

        return stringArray[0].uppercased() + stringArray[1..<stringArray.count]
    }
}
