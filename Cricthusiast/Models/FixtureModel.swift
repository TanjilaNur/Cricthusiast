//
//  FixtureModel.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 12/2/23.
//

import Foundation

class FixturesDataModel: Codable {
    let data: [FixtureModel]?

    init(data: [FixtureModel]?) {
        self.data = data
    }
}

// MARK: - FixtureModel
class FixtureModel: Codable {
    let resource: DatumResource?
    let id, leagueID, seasonID: Int?
    let round: String?
    let localteamID, visitorteamID: Int?
    let startingAt: String?
    let type: String?
    let status: Status?
    let note: String?
    let tossWonTeamID, winnerTeamID, manOfMatchID, manOfSeriesID: Int?
    let totalOversPlayed: Int?
    let elected: String?
    let league: Team?
    let season: Season?
    let localteam, visitorteam: Team?
    let runs: [Run]?
    let venue: Venue?

    enum CodingKeys: String, CodingKey {
        case resource, id
        case leagueID = "league_id"
        case seasonID = "season_id"
        case round
        case localteamID = "localteam_id"
        case visitorteamID = "visitorteam_id"
        case startingAt = "starting_at"
        case type, status, note
        case tossWonTeamID = "toss_won_team_id"
        case winnerTeamID = "winner_team_id"
        case manOfMatchID = "man_of_match_id"
        case manOfSeriesID = "man_of_series_id"
        case totalOversPlayed = "total_overs_played"
        case elected
        case league, season, localteam, visitorteam, runs, venue
    }

    init(resource: DatumResource?, id: Int?, leagueID: Int?, seasonID: Int?, round: String?, localteamID: Int?, visitorteamID: Int?, startingAt: String?, type: String?, status: Status?, note: String?, tossWonTeamID: Int?, winnerTeamID: Int?, manOfMatchID: Int?, manOfSeriesID: Int?, totalOversPlayed: Int?, elected: String?, league: Team?, season: Season?, localteam: Team?, visitorteam: Team?, runs: [Run]?, venue: Venue?) {
        self.resource = resource
        self.id = id
        self.leagueID = leagueID
        self.seasonID = seasonID
        self.round = round
        self.localteamID = localteamID
        self.visitorteamID = visitorteamID
        self.startingAt = startingAt
        self.type = type
        self.status = status
        self.note = note
        self.tossWonTeamID = tossWonTeamID
        self.winnerTeamID = winnerTeamID
        self.manOfMatchID = manOfMatchID
        self.manOfSeriesID = manOfSeriesID
        self.totalOversPlayed = totalOversPlayed
        self.elected = elected
        self.league = league
        self.season = season
        self.localteam = localteam
        self.visitorteam = visitorteam
        self.runs = runs
        self.venue = venue
    }
}

// MARK: - Team
class Team: Codable {
    let resource: LeagueResource?
    let id, seasonID, countryID: Int?
    let name, code: String?
    let imagePath: String?
    let type: LeagueType?
    let updatedAt: String?
    let nationalTeam: Bool?
    let results: [FixtureInfoModel]?

    enum CodingKeys: String, CodingKey {
        case resource, id
        case seasonID = "season_id"
        case countryID = "country_id"
        case name, code
        case imagePath = "image_path"
        case type, results
        case updatedAt = "updated_at"
        case nationalTeam = "national_team"
    }

    init(resource: LeagueResource?, id: Int?, seasonID: Int?, countryID: Int?, name: String?, code: String?, imagePath: String?, type: LeagueType?, updatedAt: String?, nationalTeam: Bool?, results: [FixtureInfoModel]?) {
        self.resource = resource
        self.id = id
        self.seasonID = seasonID
        self.countryID = countryID
        self.name = name
        self.code = code
        self.imagePath = imagePath
        self.type = type
        self.updatedAt = updatedAt
        self.nationalTeam = nationalTeam
        self.results = results
    }
}

enum LeagueResource: String, Codable {
    case leagues = "leagues"
    case teams = "teams"
}

enum LeagueType: String, Codable {
    case league = "league"
    case phase = "phase"
}


enum DatumResource: String, Codable {
    case fixtures = "fixtures"
}

// MARK: - Run
class Run: Codable {
    let resource: RunResource?
    let id, fixtureID, teamID, inning: Int?
    let score, wickets: Int?
    let overs: Double?
    let pp1: String?
    let pp2: String?
    let pp3: String?
    let updatedAt: String?
    let team: Team?

    enum CodingKeys: String, CodingKey {
        case resource, id
        case fixtureID = "fixture_id"
        case teamID = "team_id"
        case inning, score, wickets, overs, pp1, pp2, pp3
        case updatedAt = "updated_at"
        case team
    }

    init(resource: RunResource?, id: Int?, fixtureID: Int?, teamID: Int?, inning: Int?, score: Int?, wickets: Int?, overs: Double?, pp1: String?, pp2: String?, pp3: String?, updatedAt: String?,team: Team?) {
        self.resource = resource
        self.id = id
        self.fixtureID = fixtureID
        self.teamID = teamID
        self.inning = inning
        self.score = score
        self.wickets = wickets
        self.overs = overs
        self.pp1 = pp1
        self.pp2 = pp2
        self.pp3 = pp3
        self.updatedAt = updatedAt
        self.team = team
    }
}


// MARK: - RunResource

enum RunResource: String, Codable {
    case runs = "runs"
}

// MARK: - Season
class Season: Codable {
    let resource: SeasonResource?
    let id, leagueID: Int?
    let name, code: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case resource, id
        case leagueID = "league_id"
        case name, code
        case updatedAt = "updated_at"
    }

    init(resource: SeasonResource?, id: Int?, leagueID: Int?, name: String?, code: String?, updatedAt: String?) {
        self.resource = resource
        self.id = id
        self.leagueID = leagueID
        self.name = name
        self.code = code
        self.updatedAt = updatedAt
    }
}

// MARK: - SeasonResource
enum SeasonResource: String, Codable {
    case seasons = "seasons"
}


// MARK: - Venue
class Venue: Codable {
    let resource: VenueResource?
    let id, countryID: Int?
    let name, city: String?
    let imagePath: String?
    let capacity: Int?
    let floodlight: Bool?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case resource, id
        case countryID = "country_id"
        case name, city
        case imagePath = "image_path"
        case capacity, floodlight
        case updatedAt = "updated_at"
    }

    init(resource: VenueResource?, id: Int?, countryID: Int?, name: String?, city: String?, imagePath: String?, capacity: Int?, floodlight: Bool?, updatedAt: String?) {
        self.resource = resource
        self.id = id
        self.countryID = countryID
        self.name = name
        self.city = city
        self.imagePath = imagePath
        self.capacity = capacity
        self.floodlight = floodlight
        self.updatedAt = updatedAt
    }
}

// MARK: - VenueResource

enum VenueResource: String, Codable {
    case venues = "venues"
}


enum Status: String, Codable {
    case aban = "Aban."
    case finished = "Finished"
    case ns = "NS"
    case postponed = "Postp."
    case cancelled = "Cancl."
    case firstInnings = "1st Innings"
    case secondInnings = "2nd Innings"
    case thirdInnings = "3rd Innings"
    case forthInnings = "4th Innings"
    case stumpDay1 = "Stump Day 1"
    case stumpDay2 = "Stump Day 2"
    case stumpDay3 = "Stump Day 3"
    case stumpDay4 = "Stump Day 4"
    case stumpDay5 = "Stump Day 5"
    case stumpDay6 = "Stump Day 6"
    case inningsBreak = "Innings Break"
    case teamBreak = "Tea Break"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case interrupted = "Int."
    case delayed = "Delayed"
}
