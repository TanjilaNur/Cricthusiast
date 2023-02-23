//
//  UpcomingViewModel.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 3/2/23.
//

import Foundation

struct MatchInfoTVCellModel {
    let leagueName: String
    let leagueImgUrl: String
    let season: String
    let round: String
    let matchType: String
    let timeStamp: String
    let tossWinner: String
    let elected: String
    let status: String
    let note: String
    let manOfMatch: String
    let manOfMatchId: Int
    let manOfMatchImage : String
    let manOfmatchPosition : String
    let firstUmpire: String
    let secondUmpire: String
    let tvUmpire: String
    let referee: String
    let venueImage: String
    let venueStadium: String
    let venueCity: String
    let venueCapacity: String
}

class MatchDetailsViewModel {
    var matchTitle:String?

    var ltFlagUrl: String?
    var vtFlagUrl: String?
    
    var ltCCode: String?
    var vtCCode: String?
    
    var ltScore: String?
    var vtScore: String?
    
    var ltWickets: String?
    var vtWickets: String?
    
    var ltOver:String?
    var vtOver:String?

    var matchNote:String?
    
    
    @Published var isLoading = false
    
    @Published var venueImageUrl: String?
    //Info
    @Published var matchInfoTVCellModel: MatchInfoTVCellModel?
    
    //Scorecard
    @Published var ltScoreTVCellModels : [[ScoreTableViewCellModel]] = []
    @Published var vtScoreTVCellModels : [[ScoreTableViewCellModel]] = []
    
    //Squad
    var ltSquadCellModels: [SquadCollectionViewCellModel] = []
    var vtSquadCellModels: [SquadCollectionViewCellModel] = []
    
    @Published var finalSquadModel: [SquadCollectionViewCellModel] = []
    @Published var teamNames: [String] = []
    @Published var isRecent: Bool?
    
    @Published var error: Error?
    
    private func fetchFixtureDetailsFrom(id: Int, completion: @escaping (Result<FixtureInfoModel?,Error>) -> ()) {
        self.isLoading = true
        ServiceHandler.shared.fetchFixtureById(id: id) {[weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let data):
                completion(.success(data))
                
                self.matchTitle = "\(data?.league?.name ?? ""),\(data?.season?.name ?? "")"
                self.ltFlagUrl = data?.localteam?.imagePath
                self.vtFlagUrl = data?.visitorteam?.imagePath
                self.ltCCode = data?.localteam?.code
                self.vtCCode = data?.visitorteam?.code
                self.ltScore = data?.runs?.first?.score?.description
                self.vtScore = data?.runs?.last?.score?.description
                self.ltWickets = data?.runs?.first?.wickets?.description
                self.vtWickets = data?.runs?.last?.wickets?.description
                self.ltOver = data?.runs?.first?.overs?.description
                self.vtOver = data?.runs?.last?.overs?.description
                self.matchNote = data?.note
                
                self.isLoading = false
            case .failure(let error):
                self.isLoading = false
                print("Error found \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func fetchSquadInfo(id: Int) {
        fetchFixtureDetailsFrom(id: id) {[weak self] result in
            
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                
                
                if data?.status != .ns {
                    self.isRecent = true
                    
                    let ltSquad = data?.lineup?.filter({ player in
                        player.lineup?.teamID == data?.runs?.first?.teamID
                    })
                    
                    let vtSquad = data?.lineup?.filter({ player in
                        player.lineup?.teamID == data?.runs?.last?.teamID
                    })
                    
                    let localTeamName = data?.runs?.first?.team?.name ?? ""
                    let visitorTeamName = data?.runs?.last?.team?.name ?? ""
                    
                    self.teamNames = [localTeamName,visitorTeamName]
                    
                    self.ltSquadCellModels = ltSquad?.compactMap({ manofmatch in
                        SquadCollectionViewCellModel(
                            playerId: manofmatch.id ?? -1,
                            playerName: manofmatch.lastname ?? "N/A",
                            playerImageUrl: manofmatch.imagePath ?? "N/A" ,
                            playerPosition: manofmatch.position?.name ?? "N/A",
                            isCaptain: manofmatch.lineup?.captain ?? false,
                            isWicketKeeper: manofmatch.lineup?.wicketkeeper ?? false)
                    }) ?? []
                    
                    self.vtSquadCellModels = vtSquad?.compactMap({ manofmatch in
                        SquadCollectionViewCellModel(
                            playerId: manofmatch.id ?? -1,
                            playerName: manofmatch.lastname ?? "N/A",
                            playerImageUrl: manofmatch.imagePath ?? "N/A" ,
                            playerPosition: manofmatch.position?.name ?? "N/A",
                            isCaptain: manofmatch.lineup?.captain ?? false,
                            isWicketKeeper: manofmatch.lineup?.wicketkeeper ?? false)
                    }) ?? []
                    self.createFinalSquadModel()
                } else {
                    self.isRecent = false
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createFinalSquadModel(){
        var playerArr: [SquadCollectionViewCellModel] = []
        while !(ltSquadCellModels.isEmpty) && !(vtSquadCellModels.isEmpty) {
            let ltFirstValue = ltSquadCellModels.removeFirst()
            let vtFirstValue = vtSquadCellModels.removeFirst()
            
            playerArr.append(contentsOf: [ltFirstValue,vtFirstValue])
        }
        finalSquadModel = playerArr
    }
    
    func getMatchInfo(id: Int) {
        
        fetchFixtureDetailsFrom(id: id) {[weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let infoTVCellModel):
                guard let infoTVCellModel = infoTVCellModel else { return }
                
                self.matchInfoTVCellModel =
                MatchInfoTVCellModel(
                    leagueName: infoTVCellModel.league?.name ?? "N/A",
                    leagueImgUrl: infoTVCellModel.league?.imagePath ?? "",
                    season: infoTVCellModel.season?.name ?? "N/A",
                    round: infoTVCellModel.round ?? "N/A" ,
                    matchType: infoTVCellModel.type ?? "N/A",
                    timeStamp: formatTime(from: infoTVCellModel.startingAt ?? "") ?? "N/A",
                    tossWinner: infoTVCellModel.tosswon?.name ?? "N/A",
                    elected: infoTVCellModel.elected ?? "N/A",
                    status: infoTVCellModel.status?.rawValue ?? "N/A",
                    note: infoTVCellModel.note ?? "N/A" ,
                    manOfMatch: infoTVCellModel.manofmatch?.fullname ?? "N/A",
                    manOfMatchId: infoTVCellModel.manofmatch?.id ?? -1,
                    manOfMatchImage: infoTVCellModel.manofmatch?.imagePath ?? "N/A",
                    manOfmatchPosition: infoTVCellModel.manofmatch?.position?.name ?? "N/A",
                    firstUmpire: infoTVCellModel.firstumpire?.fullname ?? "N/A" ,
                    secondUmpire: infoTVCellModel.secondumpire?.fullname ?? "N/A" ,
                    tvUmpire: infoTVCellModel.tvumpire?.fullname ?? "N/A" ,
                    referee: infoTVCellModel.referee?.fullname ?? "N/A",
                    venueImage: infoTVCellModel.venue?.imagePath ?? "N/A",
                    venueStadium: infoTVCellModel.venue?.name ?? "Stadium not declared yet!",
                    venueCity: infoTVCellModel.venue?.city ?? "Venue city isn't declared!",
                    venueCapacity: infoTVCellModel.venue?.capacity?.description ?? "Capacity: N/A" )
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    
    //    infoTVCellModel.batting?.first?.team?.id
    func fetchScoreCardInfo(id: Int) {
        fetchFixtureDetailsFrom(id: id) {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                if data?.status == .finished {
                    self.isRecent = true
                    
                    let localTeamName = data?.runs?[0].team?.name ?? ""
                    let localTeamScore = "\(data?.runs?[0].score?.description ?? "")/\(data?.runs?[0].wickets?.description ?? "")"
                    
                    let visitorTeamName = data?.runs?[1].team?.name ?? ""
                    let visitorTeamScore = "\(data?.runs?[1].score?.description ?? "")/\(data?.runs?[1].wickets?.description ?? "")"
                    
                    self.teamNames = [localTeamName,visitorTeamName]
                    
                    let localTeamBatting = data?.batting?.filter({ batting in
                        batting.teamID == data?.runs?.first?.teamID
                    })
                    let visitorTeamBatting = data?.batting?.filter({ batting in
                        batting.teamID == data?.runs?.last?.teamID
                    })
                    
                    let localTeamBowling = data?.bowling?.filter({ bowling in
                        bowling.teamID == data?.runs?.last?.teamID
                    })
                    
                    let visitorTeamBowling = data?.bowling?.filter({ bowling in
                        bowling.teamID == data?.runs?.first?.teamID
                    })
                    
                    let ltCellBattingModels = localTeamBatting?.compactMap({ batting in
                        ScoreTableViewCellModel(playerTeamName: localTeamName, playerId: batting.playerID ?? -1, playerImageUrl: batting.batsman?.imagePath ?? "", playerName: batting.batsman?.lastname ?? "", playerOutNote: "", stackInfos: [
                            batting.score?.description,
                            batting.ball?.description,
                            batting.fourX?.description,
                            batting.sixX?.description,
                            batting.rate?.description
                        ])
                    }) ?? []
                    
                    let vtCellBattingModels = visitorTeamBatting?.compactMap({ batting in
                        ScoreTableViewCellModel(
                            playerTeamName: visitorTeamName, playerId: batting.playerID ?? -1,
                            playerImageUrl: batting.batsman?.imagePath ?? "",
                            playerName: batting.batsman?.lastname ?? "",
                            playerOutNote: "",
                            stackInfos: [
                                batting.score?.description,
                                batting.ball?.description,
                                batting.fourX?.description,
                                batting.sixX?.description,
                                batting.rate?.description
                            ])
                    }) ?? []
                    
                    let ltCellBowlingModels = localTeamBowling?.compactMap({ bowling in
                        ScoreTableViewCellModel(
                            playerTeamName: localTeamName, playerId: bowling.playerID ?? -1,
                            playerImageUrl: bowling.bowler?.imagePath ?? "",
                            playerName: bowling.bowler?.lastname ?? "",
                            playerOutNote: "",
                            stackInfos: [
                                bowling.overs?.description,
                                bowling.medians?.description,
                                bowling.runs?.description,
                                bowling.wickets?.description,
                                bowling.rate?.description
                            ])
                    }) ?? []
                    
                    let vtCellBowlingModels = visitorTeamBowling?.compactMap({ bowling in
                        ScoreTableViewCellModel(
                            playerTeamName: visitorTeamName, playerId: bowling.playerID ?? -1,
                            playerImageUrl: bowling.bowler?.imagePath ?? "",
                            playerName: bowling.bowler?.lastname ?? "",
                            playerOutNote: "",
                            stackInfos: [
                                bowling.overs?.description,
                                bowling.medians?.description,
                                bowling.runs?.description,
                                bowling.wickets?.description,
                                bowling.rate?.description
                            ])
                    }) ?? []
                    
                    self.ltScoreTVCellModels = [
                        ltCellBattingModels,ltCellBowlingModels
                    ]
                    
                    self.vtScoreTVCellModels = [
                        vtCellBattingModels, vtCellBowlingModels
                    ]
                    
                } else if (data?.status == .ns) {
                    self.isRecent = false
                } else {
                    self.isRecent = true
                    //                let localTeamName = ltScoreTVCellModels.first?.first
                    guard let runs = data?.runs, let firstTeamRuns = runs.first else { return }
                    let localTeamName = firstTeamRuns.team?.name ?? ""
                    let localTeamScore = "\(firstTeamRuns.score?.description ?? "")/\(firstTeamRuns.wickets?.description ?? "")"
                    
                    var visitorTeamName =  (firstTeamRuns.team?.code ?? "") == (data?.visitorteam?.code ?? "") ? data?.localteam?.name ?? "" : data?.visitorteam?.name ?? ""
                    var visitorTeamScore = "Yet to bat"
                    
                    if (runs.count == 2) {
                        let secondTeamRuns = runs[1]
                        visitorTeamScore = "\(secondTeamRuns.score?.description ?? "")/\(secondTeamRuns.wickets?.description ?? "")"
                    }
                    
                    let localTeamBatting = data?.batting?.filter({ batting in
                        batting.teamID == data?.runs?.first?.teamID
                    })
                    let visitorTeamBatting = data?.batting?.filter({ batting in
                        batting.teamID == data?.runs?.last?.teamID
                    })
                    
                    let localTeamBowling = data?.bowling?.filter({ bowling in
                        bowling.teamID == data?.runs?.last?.teamID
                    })
                    
                    let visitorTeamBowling = data?.bowling?.filter({ bowling in
                        bowling.teamID == data?.runs?.first?.teamID
                    })
                    
                    let ltCellBattingModels = localTeamBatting?.compactMap({ batting in
                        ScoreTableViewCellModel(playerTeamName: localTeamName, playerId: batting.playerID ?? -1, playerImageUrl: batting.batsman?.imagePath ?? "", playerName: batting.batsman?.lastname ?? "", playerOutNote: "", stackInfos: [
                            batting.score?.description,
                            batting.ball?.description,
                            batting.fourX?.description,
                            batting.sixX?.description,
                            batting.rate?.description
                        ])
                    }) ?? []
                    
                    let vtCellBattingModels = visitorTeamBatting?.compactMap({ batting in
                        ScoreTableViewCellModel(
                            playerTeamName: visitorTeamName, playerId: batting.playerID ?? -1,
                            playerImageUrl: batting.batsman?.imagePath ?? "",
                            playerName: batting.batsman?.lastname ?? "",
                            playerOutNote: "",
                            stackInfos: [
                                batting.score?.description,
                                batting.ball?.description,
                                batting.fourX?.description,
                                batting.sixX?.description,
                                batting.rate?.description
                            ])
                    }) ?? []
                    
                    let ltCellBowlingModels = localTeamBowling?.compactMap({ bowling in
                        ScoreTableViewCellModel(
                            playerTeamName: localTeamName, playerId: bowling.playerID ?? -1,
                            playerImageUrl: bowling.bowler?.imagePath ?? "",
                            playerName: bowling.bowler?.lastname ?? "",
                            playerOutNote: "",
                            stackInfos: [
                                bowling.overs?.description,
                                bowling.medians?.description,
                                bowling.runs?.description,
                                bowling.wickets?.description,
                                bowling.rate?.description
                            ])
                    }) ?? []
                    
                    let vtCellBowlingModels = visitorTeamBowling?.compactMap({ bowling in
                        ScoreTableViewCellModel(
                            playerTeamName: visitorTeamName, playerId: bowling.playerID ?? -1,
                            playerImageUrl: bowling.bowler?.imagePath ?? "",
                            playerName: bowling.bowler?.lastname ?? "",
                            playerOutNote: "",
                            stackInfos: [
                                bowling.overs?.description,
                                bowling.medians?.description,
                                bowling.runs?.description,
                                bowling.wickets?.description,
                                bowling.rate?.description
                            ])
                    }) ?? []
                    
                    self.ltScoreTVCellModels = [
                        ltCellBattingModels,ltCellBowlingModels
                    ]
                    
                    self.vtScoreTVCellModels = [
                        vtCellBattingModels, vtCellBowlingModels
                    ]
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

}
