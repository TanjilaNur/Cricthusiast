//
//  FixtureInfoModel.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 12/2/23.
//

import Foundation

// MARK: - FixtureInfoDataModel
class FixtureInfoDataModel: Codable {
    let data: FixtureInfoModel?

    init(data: FixtureInfoModel?) {
        self.data = data
    }
}

// MARK: - FixtureInfoModel
class FixtureInfoModel: Codable {
    let resource: String?
    let id, leagueID, seasonID, stageID: Int?
    let round: String?
    let localteamID, visitorteamID: Int?
    let startingAt, type: String?
    let live: Bool?
    let status: Status?
    let note: String?
    let venueID, tossWonTeamID, winnerTeamID: Int?
    let drawNoresult: String?
    let firstUmpireID, secondUmpireID, tvUmpireID, refereeID: Int?
    let manOfMatchID: Int?
    let manOfSeriesID: Int?
    let totalOversPlayed: Int?
    let elected: String?
    let superOver, followOn: Bool?
    let localteamDLData, visitorteamDLData: TeamDLData?
    let rpcOvers, rpcTarget: String?
    let batting: [Batting]?
    let bowling: [Bowling]?
    let manofmatch: Manofmatch?
    let manofseries: Manofmatch?
    let winnerteam: Tosswon?
    let tosswon: Tosswon?
    let venue: Venue?
    let league: Team?
    let season: Season?
    let runs: [Run]?
    let localteam, visitorteam: Team?
    let referee, firstumpire, secondumpire, tvumpire: Umpire?
    let lineup: [Manofmatch]?

    enum CodingKeys: String, CodingKey {
        case resource, id
        case leagueID = "league_id"
        case seasonID = "season_id"
        case stageID = "stage_id"
        case round
        case localteamID = "localteam_id"
        case visitorteamID = "visitorteam_id"
        case startingAt = "starting_at"
        case type, live, status
        case note
        case venueID = "venue_id"
        case tossWonTeamID = "toss_won_team_id"
        case winnerTeamID = "winner_team_id"
        case drawNoresult = "draw_noresult"
        case firstUmpireID = "first_umpire_id"
        case secondUmpireID = "second_umpire_id"
        case tvUmpireID = "tv_umpire_id"
        case refereeID = "referee_id"
        case manOfMatchID = "man_of_match_id"
        case manOfSeriesID = "man_of_series_id"
        case totalOversPlayed = "total_overs_played"
        case elected
        case superOver = "super_over"
        case followOn = "follow_on"
        case localteamDLData = "localteam_dl_data"
        case visitorteamDLData = "visitorteam_dl_data"
        case rpcOvers = "rpc_overs"
        case rpcTarget = "rpc_target"
        case batting, manofmatch, manofseries, tosswon, venue, bowling,lineup
        case localteam, visitorteam, league, season, runs, referee, firstumpire, secondumpire,tvumpire,winnerteam
        
    }

    init(resource: String?, id: Int?, leagueID: Int?, seasonID: Int?, stageID: Int?, round: String?, localteamID: Int?, visitorteamID: Int?, startingAt: String?, type: String?, live: Bool?, status: Status?, note: String?, venueID: Int?, tossWonTeamID: Int?, winnerTeamID: Int?, drawNoresult: String?, firstUmpireID: Int?, secondUmpireID: Int?, tvUmpireID: Int?, refereeID: Int?, manOfMatchID: Int?, manOfSeriesID: Int?, totalOversPlayed: Int?, elected: String?, superOver: Bool?, followOn: Bool?, localteamDLData: TeamDLData?, visitorteamDLData: TeamDLData?, rpcOvers: String?, rpcTarget: String?, batting: [Batting]?, manofmatch: Manofmatch?, manofseries: Manofmatch?,winnerteam: Tosswon?, tosswon: Tosswon?, venue: Venue?, localteam: Team?, visitorteam: Team?, league: Team?, season: Season?, runs: [Run]?,referee: Umpire?, firstumpire: Umpire?, secondumpire: Umpire?, tvumpire: Umpire?, bowling: [Bowling]?, lineup: [Manofmatch]?) {
        self.resource = resource
        self.id = id
        self.leagueID = leagueID
        self.seasonID = seasonID
        self.stageID = stageID
        self.round = round
        self.localteamID = localteamID
        self.visitorteamID = visitorteamID
        self.startingAt = startingAt
        self.type = type
        self.live = live
        self.status = status
        self.note = note
        self.venueID = venueID
        self.tossWonTeamID = tossWonTeamID
        self.winnerTeamID = winnerTeamID
        self.drawNoresult = drawNoresult
        self.firstUmpireID = firstUmpireID
        self.secondUmpireID = secondUmpireID
        self.tvUmpireID = tvUmpireID
        self.refereeID = refereeID
        self.manOfMatchID = manOfMatchID
        self.manOfSeriesID = manOfSeriesID
        self.totalOversPlayed = totalOversPlayed
        self.elected = elected
        self.superOver = superOver
        self.followOn = followOn
        self.localteamDLData = localteamDLData
        self.visitorteamDLData = visitorteamDLData
        self.rpcOvers = rpcOvers
        self.rpcTarget = rpcTarget
        self.batting = batting
        self.manofmatch = manofmatch
        self.manofseries = manofseries
        self.winnerteam = winnerteam
        self.tosswon = tosswon
        self.venue = venue
        self.localteam = localteam
        self.visitorteam = visitorteam
        self.league = league
        self.season = season
        self.runs = runs
        self.referee = referee
        self.firstumpire = firstumpire
        self.secondumpire = secondumpire
        self.tvumpire = tvumpire
        self.bowling = bowling
        self.lineup = lineup
    }
}

// MARK: - Lineup
class Lineup: Codable {
    let teamID: Int?
    let captain, wicketkeeper, substitution: Bool?

    enum CodingKeys: String, CodingKey {
        case teamID = "team_id"
        case captain, wicketkeeper, substitution
    }

    init(teamID: Int?, captain: Bool?, wicketkeeper: Bool?, substitution: Bool?) {
        self.teamID = teamID
        self.captain = captain
        self.wicketkeeper = wicketkeeper
        self.substitution = substitution
    }
}

// MARK: - Batting
class Batting: Codable {
    let resource: BattingResource?
    let id, sort, fixtureID, teamID: Int?
    let active: Bool?
    let scoreboard: String?
    let playerID, ball, scoreID, score: Int?
    let fourX, sixX: Int?
    let catchStumpPlayerID, runoutByID: Int?
    let batsmanoutID: Int?
    let bowlingPlayerID: Int?
    let fowScore: Int?
    let fowBalls: Double?
    let rate: Double?
    let updatedAt: String?
    let team: Tosswon?
    let batsman: Manofmatch?
    let bowler: Manofmatch?
    let result: BattingResult?

    enum CodingKeys: String, CodingKey {
        case resource, id, sort
        case fixtureID = "fixture_id"
        case teamID = "team_id"
        case active, scoreboard
        case playerID = "player_id"
        case ball
        case scoreID = "score_id"
        case score
        case fourX = "four_x"
        case sixX = "six_x"
        case catchStumpPlayerID = "catch_stump_player_id"
        case runoutByID = "runout_by_id"
        case batsmanoutID = "batsmanout_id"
        case bowlingPlayerID = "bowling_player_id"
        case fowScore = "fow_score"
        case fowBalls = "fow_balls"
        case rate
        case updatedAt = "updated_at"
        case team, batsman, bowler, result
        
    }

    init(resource: BattingResource?, id: Int?, sort: Int?, fixtureID: Int?, teamID: Int?, active: Bool?, scoreboard: String?, playerID: Int?, ball: Int?, scoreID: Int?, score: Int?, fourX: Int?, sixX: Int?, catchStumpPlayerID: Int?, runoutByID: Int?, batsmanoutID: Int?, bowlingPlayerID: Int?, fowScore: Int?, fowBalls: Double?, rate: Double?, updatedAt: String?, team: Tosswon?, batsman: Manofmatch?, bowler: Manofmatch?,localteam: Team?, visitorteam: Team?,result:BattingResult?) {
        self.resource = resource
        self.id = id
        self.sort = sort
        self.fixtureID = fixtureID
        self.teamID = teamID
        self.active = active
        self.scoreboard = scoreboard
        self.playerID = playerID
        self.ball = ball
        self.scoreID = scoreID
        self.score = score
        self.fourX = fourX
        self.sixX = sixX
        self.catchStumpPlayerID = catchStumpPlayerID
        self.runoutByID = runoutByID
        self.batsmanoutID = batsmanoutID
        self.bowlingPlayerID = bowlingPlayerID
        self.fowScore = fowScore
        self.fowBalls = fowBalls
        self.rate = rate
        self.updatedAt = updatedAt
        self.team = team
        self.batsman = batsman
        self.bowler = bowler
        self.result = result
        
    }
}

// MARK: - Batting Result
class BattingResult: Codable {
    let resource: String?
    let id: Int?
    let name: String?
    let runs: Int?
    let four, six: Bool?
    let bye, legBye, noball, noballRuns: Int?
    let isWicket, ball, out: Bool?

    enum CodingKeys: String, CodingKey {
        case resource, id, name, runs, four, six, bye
        case legBye = "leg_bye"
        case noball
        case noballRuns = "noball_runs"
        case isWicket = "is_wicket"
        case ball, out
    }

    init(resource: String?, id: Int?, name: String?, runs: Int?, four: Bool?, six: Bool?, bye: Int?, legBye: Int?, noball: Int?, noballRuns: Int?, isWicket: Bool?, ball: Bool?, out: Bool?) {
        self.resource = resource
        self.id = id
        self.name = name
        self.runs = runs
        self.four = four
        self.six = six
        self.bye = bye
        self.legBye = legBye
        self.noball = noball
        self.noballRuns = noballRuns
        self.isWicket = isWicket
        self.ball = ball
        self.out = out
    }
}

// MARK: - Bowling
class Bowling: Codable {
    let resource: BowlingResource?
    let id, sort, fixtureID, teamID: Int?
    let active: Bool?
    let scoreboard: String?
    let playerID: Int?
    let overs: Double?
    let medians, runs, wickets, wide: Int?
    let noball: Int?
    let rate: Double?
    let updatedAt: String?
    let team: Team?
    let bowler: Manofmatch?

    enum CodingKeys: String, CodingKey {
        case resource, id, sort
        case fixtureID = "fixture_id"
        case teamID = "team_id"
        case active, scoreboard
        case playerID = "player_id"
        case overs, medians, runs, wickets, wide, noball, rate
        case updatedAt = "updated_at"
        case team, bowler
    }

    init(resource: BowlingResource?, id: Int?, sort: Int?, fixtureID: Int?, teamID: Int?, active: Bool?, scoreboard: String?, playerID: Int?, overs: Double?, medians: Int?, runs: Int?, wickets: Int?, wide: Int?, noball: Int?, rate: Double?, updatedAt: String?, team: Team?, bowler: Manofmatch?) {
        self.resource = resource
        self.id = id
        self.sort = sort
        self.fixtureID = fixtureID
        self.teamID = teamID
        self.active = active
        self.scoreboard = scoreboard
        self.playerID = playerID
        self.overs = overs
        self.medians = medians
        self.runs = runs
        self.wickets = wickets
        self.wide = wide
        self.noball = noball
        self.rate = rate
        self.updatedAt = updatedAt
        self.team = team
        self.bowler = bowler
    }
}

enum BowlingResource: String, Codable {
    case bowlings = "bowlings"
}

// MARK: - Manofmatch
class Manofmatch: Codable {
    let resource: ManofmatchResource?
    let id, countryID: Int?
    let firstname, lastname, fullname: String?
    let imagePath: String?
    let dateofbirth: String?
    let gender: Gender?
    let battingstyle: String?
    let bowlingstyle: String?
    let position: Position?
    let updatedAt: String?
    let lineup: Lineup?

    enum CodingKeys: String, CodingKey {
        case resource, id
        case countryID = "country_id"
        case firstname, lastname, fullname
        case imagePath = "image_path"
        case dateofbirth, gender, battingstyle, bowlingstyle, position,lineup
        case updatedAt = "updated_at"
    }

    init(resource: ManofmatchResource?, id: Int?, countryID: Int?, firstname: String?, lastname: String?, fullname: String?, imagePath: String?, dateofbirth: String?, gender: Gender?, battingstyle: String?, bowlingstyle: String?, position: Position?,lineup:Lineup?, updatedAt: String?) {
        
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
        self.lineup = lineup
    }
}

//enum Battingstyle: String, Codable {
//    case leftHandBat = "left-hand-bat"
//    case rightHandBat = "right-hand-bat"
//}
//
//enum Bowlingstyle: String, Codable {
//    case leftArmFastMedium = "left-arm-fast-medium"
//    case rightArmFastMedium = "right-arm-fast-medium"
//    case rightArmOffbreak = "right-arm-offbreak"
//    case slowLeftArmOrthodox = "slow-left-arm-orthodox"
//}

enum Gender: String, Codable {
    case m = "m"
}


enum PositionName: String, Codable {
    case allrounder = "Allrounder"
    case batsman = "Batsman"
    case bowler = "Bowler"
    case wicketkeeper = "Wicketkeeper"
}

enum PositionResource: String, Codable {
    case positions = "positions"
}

enum ManofmatchResource: String, Codable {
    case players = "players"
}

enum BattingResource: String, Codable {
    case battings = "battings"
}

// MARK: - Tosswon
class Tosswon: Codable {
    let resource: TosswonResource?
    let id: Int?
    let name: String?
    let code: String?
    let imagePath: String?
    let countryID: Int?
    let nationalTeam: Bool?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case resource, id, name, code
        case imagePath = "image_path"
        case countryID = "country_id"
        case nationalTeam = "national_team"
        case updatedAt = "updated_at"
    }

    init(resource: TosswonResource?, id: Int?, name: String?, code: String?, imagePath: String?, countryID: Int?, nationalTeam: Bool?, updatedAt: String?) {
        self.resource = resource
        self.id = id
        self.name = name
        self.code = code
        self.imagePath = imagePath
        self.countryID = countryID
        self.nationalTeam = nationalTeam
        self.updatedAt = updatedAt
    }
}

enum TosswonResource: String, Codable {
    case teams = "teams"
}

// MARK: - TeamDLData
class TeamDLData: Codable {
    let score, overs, wicketsOut: String?

    enum CodingKeys: String, CodingKey {
        case score, overs
        case wicketsOut = "wickets_out"
    }

    init(score: String?, overs: String?, wicketsOut: String?) {
        self.score = score
        self.overs = overs
        self.wicketsOut = wicketsOut
    }
}

class Umpire: Codable {
    let resource: String?
    let id, countryID: Int?
    let firstname, lastname, fullname, dateofbirth: String?
    let gender: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case resource, id
        case countryID = "country_id"
        case firstname, lastname, fullname, dateofbirth, gender
        case updatedAt = "updated_at"
    }

    init(resource: String?, id: Int?, countryID: Int?, firstname: String?, lastname: String?, fullname: String?, dateofbirth: String?, gender: String?, updatedAt: String?) {
        self.resource = resource
        self.id = id
        self.countryID = countryID
        self.firstname = firstname
        self.lastname = lastname
        self.fullname = fullname
        self.dateofbirth = dateofbirth
        self.gender = gender
        self.updatedAt = updatedAt
    }
}
