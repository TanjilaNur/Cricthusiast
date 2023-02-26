//
//  TeamModels.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/25/23.
//

import Foundation

// MARK: - TeamInfoDataModel
class TeamsDataModel: Codable {
    let data: [TeamDataModel]?

    init(data: [TeamDataModel]?) {
        self.data = data
    }
}

// MARK: - DataClass
class TeamDataModel: Codable {
    let resource: String?
    let id: Int?
    let name, code: String?
    let imagePath: String?
    let countryID: Int?
    let nationalTeam: Bool?
    let updatedAt: String?
    let squad: [SquadElement]?

    enum CodingKeys: String, CodingKey {
        case resource, id, name, code
        case imagePath = "image_path"
        case countryID = "country_id"
        case nationalTeam = "national_team"
        case updatedAt = "updated_at"
        case squad
    }

    init(resource: String?, id: Int?, name: String?, code: String?, imagePath: String?, countryID: Int?, nationalTeam: Bool?, updatedAt: String?, squad: [SquadElement]?) {
        self.resource = resource
        self.id = id
        self.name = name
        self.code = code
        self.imagePath = imagePath
        self.countryID = countryID
        self.nationalTeam = nationalTeam
        self.updatedAt = updatedAt
        self.squad = squad
    }
}

// MARK: - SquadElement
class SquadElement: Codable {
    let resource: String?
    let id, countryID: Int?
    let firstname, lastname, fullname: String?
    let imagePath: String?
    let dateofbirth: String?
    let gender: String?
    let battingstyle: String?
    let bowlingstyle: String?
    let position: Position?
    let updatedAt: String?
    let squad: SquadSquad?

    enum CodingKeys: String, CodingKey {
        case resource, id
        case countryID = "country_id"
        case firstname, lastname, fullname
        case imagePath = "image_path"
        case dateofbirth, gender, battingstyle, bowlingstyle, position
        case updatedAt = "updated_at"
        case squad
    }

    init(resource: String?, id: Int?, countryID: Int?, firstname: String?, lastname: String?, fullname: String?, imagePath: String?, dateofbirth: String?, gender: String?, battingstyle: String?, bowlingstyle: String?, position: Position?, updatedAt: String?, squad: SquadSquad?) {
        self.resource = resource
        self.id = id
        self.countryID = countryID
        self.firstname = firstname
        self.lastname = lastname
        self.fullname = fullname
        self.imagePath = imagePath
        self.dateofbirth = dateofbirth
        self.gender = gender
        self.battingstyle = battingstyle
        self.bowlingstyle = bowlingstyle
        self.position = position
        self.updatedAt = updatedAt
        self.squad = squad
    }
}

// MARK: - SquadSquad
class SquadSquad: Codable {
    let seasonID: Int?

    enum CodingKeys: String, CodingKey {
        case seasonID = "season_id"
    }

    init(seasonID: Int?) {
        self.seasonID = seasonID
    }
}


