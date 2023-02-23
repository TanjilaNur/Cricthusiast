//
//  File.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/10/23.
//

import Alamofire
import Foundation

class APIHandler {
//    static let apiKey = "aGypft0iQPFUBpefG6U1QInmd9OvUDsadwYyMFJZQSGud9rb80dmNlruCfuL"
    static let apiKey = "12ZsB3C2og5c7fhinci8yffaGN6OPMR8BvJpxqTJnCW6gLjrU97brzVm5wH1"
    static let baseUrl = "https://cricket.sportmonks.com/api/v2.0"
    static let playersEndPoint = "\(baseUrl)/players"
    static let fixturesEndPoint = "\(baseUrl)/fixtures"
    static let liveEndpoint = "\(baseUrl)/livescores"
    static let globalRankingEndpoint = "\(baseUrl)/team-rankings"
    
    static func getAllPlayersEndPoint() -> String {
        "\(playersEndPoint)"
    }
    
    static func fetchPlayerEndpointBased(on id: Int) -> String {
        "\(playersEndPoint)/\(id)"
    }
    
    static func getFixtureEndpointBased(on id: Int) -> String {
        "\(fixturesEndPoint)/\(id)"
    }
}

class ServiceHandler {
    enum ServiceError: Error {
        case noDataError
        case jsonDecodingError
        
        var localizedDescription: String {
            switch self {
            case .noDataError:
                return NSLocalizedString("No data found", comment: "")
            case .jsonDecodingError:
                return NSLocalizedString("JSON decoding failed", comment: "")
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
        
        sessionManager.request(APIHandler.getAllPlayersEndPoint(),parameters: parameters).response { responseData in
            
            guard let data = responseData.data else {
                return
            }
            
            do {
                let playerData = try JSONDecoder().decode(PlayersDataModel.self, from: data)
                
                completion(.success(playerData.data))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchPlayerById(id: Int, completion: @escaping (Result<(PlayerInfoModel?), Error>) -> ())  {
        
        let parameters = [
            "api_token": APIHandler.apiKey,
            "include": "country,career,career.season,currentteams,teams"
        ]
        
        sessionManager.request(APIHandler.fetchPlayerEndpointBased(on: id), parameters: parameters).validate().response { responseData in
            guard let data = responseData.data else {
                return
            }
            print(responseData.response?.statusCode, responseData.request?.url)
            do {
                let playerData = try JSONDecoder().decode(PlayerInfoDataModel.self, from: data)
                completion(.success(playerData.data))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchData<T: Codable> (
        from endpoint: String,
        using parameters: [String:String] = [:],
        completion: @escaping (Result<T, Error>) -> ()
    ) {
        
        sessionManager.request(endpoint,parameters: parameters).validate().response { responseData in
    
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
        
    }
    
    func fetchFixtureById(id: Int, completion: @escaping (Result<(FixtureInfoModel?), Error>) -> ()) {
        let endpoint = APIHandler.getFixtureEndpointBased(on: id)
        let parameters = [
            "api_token": APIHandler.apiKey,
            "include": "batting.team,batting.bowler,batting.batsman,manofseries,manofmatch,tosswon,venue,localteam,visitorteam,runs.team,season,league,firstumpire,secondumpire,tvumpire,referee,batting.batsmanout,batting.catchstump,batting.runoutby,bowling.team,bowling.bowler,lineup,winnerteam,batting.result,localteam.results,visitorteam.results"
        ]
        
        fetchData(from: endpoint,using: parameters) { (result: Result<FixtureInfoDataModel, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                //dump(data)
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
        fetchAllFixtures(startDate: getCurrentDateTime(), endDate: getTwentyDaysLaterDateTime(), isAscending: true ,completion: completion)
    }
    
    func fetchGlobalRanking(completion: @escaping (Result<([MatchTypeModel]?), Error>)->()) {
        let endpoint = APIHandler.globalRankingEndpoint
        let parameters =  [
            "api_token": APIHandler.apiKey,
            "include": "teams",
            "filter[type]": "TEST"
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
}

func findTimeDifference(from timeString: String) -> DateComponents? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    guard let time = formatter.date(from: timeString) else { return nil }

    let difference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: time)
    return difference
}

func findFormattedTimeInDC(from components: DateComponents?) -> String? {
    guard let components = components else { return nil }
//    let calendar = Calendar.current
//    guard let date = calendar.date(from: components) else { return nil }
    
    let outputFormatter = DateComponentsFormatter()
    outputFormatter.allowedUnits = [.day, .hour, .minute, .second]
    outputFormatter.maximumUnitCount = 7
    outputFormatter.unitsStyle = .full
    outputFormatter.zeroFormattingBehavior = .default

    return outputFormatter.string(from: components)
}

func formatTime(from timeString: String) -> String? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    guard let time = formatter.date(from: timeString) else { return nil }

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd-MM-yyyy, hh:mm a"
    outputFormatter.amSymbol = "AM"
    outputFormatter.pmSymbol = "PM"

    return outputFormatter.string(from: time)
}

func getCurrentDateTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: Date())
}

func getTwentyDaysAgoDateTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let today = Date()
    let fifteenDaysAgo = Calendar.current.date(byAdding: .day, value: -20, to: today)!
    return formatter.string(from: fifteenDaysAgo)
}

func getTwentyDaysLaterDateTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let today = Date()
    let fifteenDaysAgo = Calendar.current.date(byAdding: .day, value: 20, to: today)!
    return formatter.string(from: fifteenDaysAgo)
}


//final class APICaller {
//    static let shared = APICaller()
//    let context = Constants.context
//
//    private init() {}
//
//    struct Constant {
//        static let newsURL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=6ca32dc780bc4c648d3e89217e19bc48"
//    }
//
//    public func fetchDataFromAPI(query: String, category: CategoryList,completion: @escaping (Result<[ArticleModel], Error>) -> Void) {
//
//        let news = CoreDataManager.shared.getMatchedRecords(query: query, category: category)
//        print(news)
//        var urlString = Constant.newsURL
//
//        if category != .all {
//            urlString.append("&category=\(category.rawValue)")
//        }
//        print(Constant.newsURL)
//
//        guard let url = URL(string:urlString) else { return }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            else if let data = data {
//                do {
//                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
//                    print("Articles:\(result.articles.count)")
//                    completion(.success(result.articles))
//                } catch {
//                    completion(.failure(error))
//                }
//
//            }
//        }
//        task.resume()
//    }
//}
