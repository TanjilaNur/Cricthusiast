//
//  GlobalTeamsRankingModel.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 22/2/23.
//

import Foundation


// MARK: - GlobalTeamsRankingModel
class GlobalTeamsRankingModel: Codable {
    let data: [MatchTypeModel]?

    init(data: [MatchTypeModel]?) {
        self.data = data
    }
}

// MARK: - Datum
class MatchTypeModel: Codable {
    let resource, type: String?
    let gender, updatedAt: String?
    let team: [TeamRanking]?

    enum CodingKeys: String, CodingKey {
        case resource, type, gender
        case updatedAt = "updated_at"
        case team
    }

    init(resource: String?, type: String?, gender: String?, updatedAt: String?, team: [TeamRanking]?) {
        self.resource = resource
        self.type = type
        self.gender = gender
        self.updatedAt = updatedAt
        self.team = team
    }
}

// MARK: - Team
class TeamRanking: Codable {
    let resource: Resource?
    let id: Int?
    let name, code: String?
    let imagePath: String?
    let countryID: Int?
    let nationalTeam: Bool?
    let position: Int?
    let updatedAt: String?
    let ranking: Ranking?

    enum CodingKeys: String, CodingKey {
        case resource, id, name, code
        case imagePath = "image_path"
        case countryID = "country_id"
        case nationalTeam = "national_team"
        case position
        case updatedAt = "updated_at"
        case ranking
    }

    init(resource: Resource?, id: Int?, name: String?, code: String?, imagePath: String?, countryID: Int?, nationalTeam: Bool?, position: Int?, updatedAt: String?, ranking: Ranking?) {
        self.resource = resource
        self.id = id
        self.name = name
        self.code = code
        self.imagePath = imagePath
        self.countryID = countryID
        self.nationalTeam = nationalTeam
        self.position = position
        self.updatedAt = updatedAt
        self.ranking = ranking
    }
}

// MARK: - Ranking
class Ranking: Codable {
    let position, matches, points, rating: Int?

    init(position: Int?, matches: Int?, points: Int?, rating: Int?) {
        self.position = position
        self.matches = matches
        self.points = points
        self.rating = rating
    }
}

enum Resource: String, Codable {
    case teams = "teams"
}
