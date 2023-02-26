//
//  File.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/10/23.
//

import Alamofire
import Foundation

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class APIHandler {
    static let newsApiKey = "a4b9088d8fcf4acfb7bc0041d63efd13"
    //3c2608029e3c460db2b1a00000871909
    //a4b9088d8fcf4acfb7bc0041d63efd13
    //2c4f79f6d523420683ad2e558578ae20
    //5f32e275af4d45f4aa6609d4ac880fcc
    static let newsBaseUrl = "https://newsapi.org/v2"
    static let newsEndPoint = "\(newsBaseUrl)/everything"
    
//    static let apiKey2 = "aGypft0iQPFUBpefG6U1QInmd9OvUDsadwYyMFJZQSGud9rb80dmNlruCfuL"
    static let apiKey = "12ZsB3C2og5c7fhinci8yffaGN6OPMR8BvJpxqTJnCW6gLjrU97brzVm5wH1"
    static let baseUrl = "https://cricket.sportmonks.com/api/v2.0"
    static let playersEndPoint = "\(baseUrl)/players"
    static let fixturesEndPoint = "\(baseUrl)/fixtures"
    static let liveEndpoint = "\(baseUrl)/livescores"
    static let globalRankingEndpoint = "\(baseUrl)/team-rankings"
    static let teamsEndpoint = "\(baseUrl)/teams"
    
    
    static func getAllPlayersEndPoint() -> String {
        "\(playersEndPoint)"
    }
    
    static func makePlayerEndpointBy(id: Int) -> String {
        "\(playersEndPoint)/\(id)"
    }
    
    static func makeFixtureEndpointBy(id: Int) -> String {
        "\(fixturesEndPoint)/\(id)"
    }
    
    static func getSquadEndpointBy(id: Int) -> String {
        "\(fixturesEndPoint)/\(id)"
    }
    
    static func getTeamSquadEndpointBy(id: Int) -> String {
        "\(teamsEndpoint)/\(id)"
    }
    
    
}

class ServiceHandler {
    enum ServiceError: Error {
        case noDataError
        case jsonDecodingError
        case noInternetError
        
        var localizedDescription: String {
            switch self {
            case .noDataError:
                return NSLocalizedString("No data found", comment: "")
            case .jsonDecodingError:
                return NSLocalizedString("JSON decoding failed", comment: "")
            case .noInternetError:
                return NSLocalizedString("No Internet connection available!", comment: "")
            }
            
        }
    }
    
    static let shared = ServiceHandler()
    
    let sessionManager = Session(configuration: .default)
    
    private init() {}
    
    
    func fetchLiveMatch(completion: @escaping (Result<([FixtureModel]?), Error>) -> ()) {
        let endpoint = APIHandler.liveEndpoint
        let parameters = [
            "api_token": APIHandler.apiKey,
            "fields[fixtures]": "id,league_id,season_id,round,localteam_id,visitorteam_id,starting_at,type,status,note,toss_won_team_id,winner_team_id,man_of_match_id,man_of_series_id,elected,total_overs_played",
            "include": "localteam,visitorteam,venue,season,league,runs.team"
        ]
        
        fetchData(from: endpoint,using: parameters) { (result: Result<FixturesDataModel, Error>) in
            switch result {
            case .success(let data):
                completion(.success(data.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func fetchAllPlayers(completion: @escaping (Result<([PlayerModel]?), Error>) -> ()) {
        
        let parameters = [
            "api_token": APIHandler.apiKey,
            "fields[players]": "id,image_path,fullname",
            "include": "country"
        ]
        
        fetchData(from: APIHandler.getAllPlayersEndPoint(),using: parameters) { (result: Result<PlayersDataModel, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                completion(.success(data.data))
            }
        }
    }
    
    func fetchPlayerById(id: Int, completion: @escaping (Result<(PlayerInfoModel?), Error>) -> ())  {
        
        let parameters = [
            "api_token": APIHandler.apiKey,
            "include": "country,career,career.season,currentteams,teams"
        ]
        fetchData(from: APIHandler.makePlayerEndpointBy(id: id),using: parameters) { (result: Result<PlayerInfoDataModel, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                completion(.success(data.data))
            }
        }
    }
    
    func fetchData<T: Codable> (
        from endpoint: String,
        using parameters: [String:String] = [:],
        completion: @escaping (Result<T, Error>) -> ()
    ) {
        if Connectivity.isConnectedToInternet {
            sessionManager.request(endpoint,parameters: parameters).validate().response { responseData in
                print("\(responseData.response?.statusCode), \(responseData.response?.url)")
                guard let data = responseData.data else {
                    completion(.failure(ServiceError.noDataError))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                    
                } catch {
                    completion(.failure(ServiceError.jsonDecodingError))
                    print("Error occurred \(error)")
                    
                }
            }
        } else {
            completion(.failure(ServiceError.noInternetError))
        }
    }
    
    func fetchFixtureById(id: Int, completion: @escaping (Result<(FixtureInfoModel?), Error>) -> ()) {
        let endpoint = APIHandler.makeFixtureEndpointBy(id: id)
        let parameters = [
            "api_token": APIHandler.apiKey,
            "include": "batting.team,batting.bowler,batting.batsman,manofseries,manofmatch,tosswon,venue,localteam,visitorteam,runs.team,season,league,firstumpire,secondumpire,tvumpire,referee,batting.batsmanout,batting.catchstump,batting.runoutby,bowling.team,bowling.bowler,lineup,winnerteam,batting.result,localteam.results,visitorteam.results"
        ]
        
        fetchData(from: endpoint,using: parameters) { (result: Result<FixtureInfoDataModel, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                completion(.success(data.data))
            }
        }
    }
    
    func fetchAllFixtures(startDate: String, endDate: String, isAscending: Bool, completion: @escaping (Result<([FixtureModel]?), Error>) -> ()) {
        let endpoint = APIHandler.fixturesEndPoint
        
        var parameters: [String: String] = [:]
        if isAscending == false {
            
            parameters = [
                "api_token": APIHandler.apiKey,
                "sort": "-starting_at",
                "filter[starts_between]": "\(startDate),\(endDate)",
                "fields[fixtures]": "id,league_id,season_id,round,localteam_id,visitorteam_id,starting_at,type,status,note,toss_won_team_id,winner_team_id,man_of_match_id,man_of_series_id,elected,total_overs_played",
                "include": "localteam,visitorteam,venue,season,league,runs.team"
            ]
        } else {
            parameters = [
                "api_token": APIHandler.apiKey,
                "sort": "starting_at",
                "filter[starts_between]": "\(startDate),\(endDate)",
                "fields[fixtures]": "id,league_id,season_id,round,localteam_id,visitorteam_id,starting_at,type,status,note,toss_won_team_id,winner_team_id,man_of_match_id,man_of_series_id,elected,total_overs_played",
                "include": "localteam,visitorteam,venue,season,league,runs.team"
            ]
        }
        
        fetchData(from: endpoint,using: parameters) { (result: Result<FixturesDataModel, Error>) in
            switch result {
            case .success(let data):
                completion(.success(data.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchRecentMatchFixture(completion: @escaping (Result<([FixtureModel]?), Error>)->()) {
        fetchAllFixtures(startDate: getTwentyDaysAgoDateTime(), endDate: getCurrentDateTime(), isAscending: false,completion: completion)
    }
    
    func fetchUpcomingMatchFixture(completion: @escaping (Result<([FixtureModel]?), Error>)->()) {
        fetchAllFixtures(startDate: getCurrentDateTime(), endDate: getThirtyDaysLaterDateTime(), isAscending: true ,completion: completion)
    }
    
    func fetchGlobalRanking(type: String,completion: @escaping (Result<([MatchTypeModel]?), Error>)->()) {
        let endpoint = APIHandler.globalRankingEndpoint
        let parameters =  [
            "api_token": APIHandler.apiKey,
            "include": "teams",
            "filter[type]": type
        ]
        
        fetchData(from: endpoint,using: parameters) { (result: Result<GlobalTeamsRankingModel, Error>) in
            switch result {
            case .success(let data):
                completion(.success(data.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchAllTeams(completion: @escaping (Result<([TeamDataModel]?), Error>)->()) {
        let endpoint = APIHandler.teamsEndpoint
        let parameters = [
            "api_token": APIHandler.apiKey
        ]
        
        
        fetchData(from: endpoint,using: parameters) { (result: Result<TeamsDataModel, Error>) in
            switch result {
            case .success(let data):
                completion(.success(data.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTeamSquad(id: Int, completion: @escaping (Result<(TeamDataModel?), Error>)->()) {
        let endpoint = APIHandler.getTeamSquadEndpointBy(id: id)
        let parameters = [
            "api_token": APIHandler.apiKey,
            "include": "squad"
        ]
        
        
        fetchData(from: endpoint,using: parameters) { (result: Result<TeamsInfoDataModel, Error>) in
            switch result {
            case .success(let data):
                completion(.success(data.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchAllNews(completion: @escaping (Result<([ArticleModel]?), Error>) -> ()) {
        let endpoint = APIHandler.newsEndPoint
        let parameters = [
            "apiKey": APIHandler.newsApiKey,
                "q": "cricket",
                "pageSize": "20",
                "to": getCurrentDateTime()
            ]

        fetchData(from: endpoint,using: parameters) { (result: Result<NewsAPIModel, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                completion(.success(data.articles))
            }
        }
    }
}






