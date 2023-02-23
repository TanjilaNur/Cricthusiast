//
//  PlayersModel.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/9/23.
//

import Foundation

// MARK: - PlayersDataModels
class PlayersDataModel: Codable {
    let data: [PlayerModel]?

    init(data: [PlayerModel]?) {
        self.data = data
    }
}

// MARK: - PlayerModel
class PlayerModel: Codable {
    let resource: Resource?
    let id: Int?
    let fullname: String?
    let imagePath: String?
    let updatedAt: String?
    let country: Country?

    enum CodingKeys: String, CodingKey {
        case resource, id, fullname, country
        case imagePath = "image_path"
        case updatedAt = "updated_at"
    }
    
    enum Resource: String, Codable {
        case players = "players"
    }

    init(resource: Resource?, id: Int?, fullname: String?, imagePath: String?, updatedAt: String?, country: Country) {
        self.resource = resource
        self.id = id
        self.fullname = fullname
        self.imagePath = imagePath
        self.updatedAt = updatedAt
        self.country = country
    }
}

// MARK: - Country
class Country: Codable {
    let resource: String?
    let id, continentID: Int?
    let name: String?
    let imagePath: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case resource, id
        case continentID = "continent_id"
        case name
        case imagePath = "image_path"
        case updatedAt = "updated_at"
    }

    init(resource: String?, id: Int?, continentID: Int?, name: String?, imagePath: String?, updatedAt: String?) {
        self.resource = resource
        self.id = id
        self.continentID = continentID
        self.name = name
        self.imagePath = imagePath
        self.updatedAt = updatedAt
    }
}

