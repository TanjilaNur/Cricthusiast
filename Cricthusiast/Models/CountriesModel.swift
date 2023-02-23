//
//  CountriesModel.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/9/23.
//

import Foundation

// MARK: - CountriesDataModels
class CountriesDataModel: Codable {
    let data: [CountryModel]?

    init(data: [CountryModel]?) {
        self.data = data
    }
}

// MARK: - Datum
class CountryModel: Codable {
    let resource: Resource?
    let id: Int?
    let name: String?
    let imagePath: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case resource, id, name
        case imagePath = "image_path"
        case updatedAt = "updated_at"
    }
    
    enum Resource: String, Codable {
        case countries = "countries"
    }

    init(resource: Resource?, id: Int?, name: String?, imagePath: String?, updatedAt: String?) {
        self.resource = resource
        self.id = id
        self.name = name
        self.imagePath = imagePath
        self.updatedAt = updatedAt
    }
}
