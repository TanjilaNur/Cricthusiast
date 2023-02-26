//
//  RecentMatchViewModel.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 3/2/23.
//

import Foundation

struct MatchCellModel {
    let id: Int
    let isLive: Bool
    let localTeamCode: String
    let visitorTeamCode: String
    let localTeamScore: String
    let visistorTeamScore: String
    let localTeamOver: String
    let visitorTeamOver: String
    let matchNote: String
    let matchType: String
    let localTeamImageUrl: String
    let visitorTeamImageUrl: String
    let tag: Int
}

class MatchViewModel{
    
    enum MatchLeagueStatus {
    case t20,odi, all, test
    }
    
    @Published var fixtureModels: [MatchCellModel] = []
    @Published var isLoading = false
    
    @Published var error: Error?
    
    var matchLeagueStatus = MatchLeagueStatus.all
    
    func fetchData(tag: Int, segmentIdx: Int) {
        self.isLoading = true
        
        if tag == 0 {
            ServiceHandler.shared.fetchLiveMatch { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let fixtures):
                    guard let fixtures = fixtures else { return }
                    
                    self.fixtureModels = fixtures.compactMap({
                        
                        guard let runs = $0.runs, let firstTeamRuns = runs.first else { return MatchCellModel(
                            id: $0.id ?? -1,
                            isLive: true,
                            localTeamCode: $0.localteam?.code ?? "",
                            visitorTeamCode: $0.visitorteam?.code ?? "",
                            localTeamScore: "",
                            visistorTeamScore: "" ,
                            localTeamOver: "",
                            visitorTeamOver: "",
                            matchNote: $0.startingAt ?? "",
                            matchType: "\($0.league?.name ?? ""), \($0.season?.name ?? "")",
                            localTeamImageUrl: $0.localteam?.imagePath ?? "",
                            visitorTeamImageUrl: $0.visitorteam?.imagePath ?? "",
                            tag: 0) }
                        
                        if (runs.count == 1) {
                            return MatchCellModel(
                                id: $0.id ?? -1,
                                isLive: true,
                                localTeamCode: firstTeamRuns.team?.code ?? "",
                                visitorTeamCode: (firstTeamRuns.team?.code ?? "") == ($0.visitorteam?.code ?? "") ? $0.localteam?.code ?? "" : $0.visitorteam?.code ?? "",
                                localTeamScore: "\(firstTeamRuns.score?.description ?? "")/\(firstTeamRuns.wickets?.description ?? "")",
                                visistorTeamScore: "Yet to bat" ,
                                localTeamOver: "\(firstTeamRuns.overs?.description ?? "") Overs",
                                visitorTeamOver: "",
                                matchNote: $0.note ?? "",
                                matchType: "\($0.league?.name ?? ""), \($0.season?.name ?? "")",
                                localTeamImageUrl: firstTeamRuns.team?.imagePath ?? "",
                                visitorTeamImageUrl: (firstTeamRuns.team?.code ?? "") == ($0.visitorteam?.code ?? "") ? $0.localteam?.imagePath ?? "" : $0.visitorteam?.imagePath ?? "",
                                tag: tag)
                        }
                        let secondTeamRuns = runs[1]
                        return MatchCellModel(
                            id: $0.id ?? -1,
                            isLive: true,
                            localTeamCode: firstTeamRuns.team?.code ?? "",
                            visitorTeamCode: secondTeamRuns.team?.code ?? "",
                            localTeamScore: "\(firstTeamRuns.score?.description ?? "")/\(firstTeamRuns.wickets?.description ?? "")",
                            visistorTeamScore: "\(secondTeamRuns.score?.description ?? "")/\(secondTeamRuns.wickets?.description ?? "")",
                            localTeamOver: "\(firstTeamRuns.overs?.description ?? "") Overs",
                            visitorTeamOver: "\(secondTeamRuns.overs?.description ?? "") Overs",
                            matchNote: $0.note ?? "",
                            matchType: "\($0.league?.name ?? ""), \($0.season?.name ?? "")",
                            localTeamImageUrl: firstTeamRuns.team?.imagePath ?? "",
                            visitorTeamImageUrl: secondTeamRuns.team?.imagePath ?? "",
                            tag: tag)
                    })
                    
                    self.isLoading = false
                case .failure(let failure):
                    print("ERROR OCCURRED\(failure)")
                    self.isLoading = false
                    self.error = failure
                }
            }
        }
        else if tag == 1{
            ServiceHandler.shared.fetchUpcomingMatchFixture { [weak self] result in
                guard let self = self else { return }
                
                
                switch result {
                case .success(let fixtures):
                    guard let fixtures = fixtures else { return }
                    
                    var filteredFixtures = fixtures.filter {
                        $0.status == .ns
                    }
                    
                    switch segmentIdx {
                    case 0:
                        filteredFixtures = filteredFixtures
                    case 1:
                        filteredFixtures = filteredFixtures.filter({
                            ($0.type ?? "") == "Test"
                        })
                    case 2:
                        filteredFixtures = filteredFixtures.filter({
                            (($0.type ?? "") == "T20") || (($0.type ?? "") == "T20I")
                        })
                    default:
                        filteredFixtures = filteredFixtures.filter({
                            ($0.type ?? "") == "ODI"
                        })
                    }
                    
                    self.fixtureModels = filteredFixtures.compactMap({
                        MatchCellModel(
                            id: $0.id ?? -1,
                            isLive: false,
                            localTeamCode: $0.localteam?.code ?? "",
                            visitorTeamCode: $0.visitorteam?.code ?? "",
                            localTeamScore: "",
                            visistorTeamScore: "" ,
                            localTeamOver: "",
                            visitorTeamOver: "",
                            matchNote: $0.startingAt ?? "",
                            matchType: "\($0.league?.name ?? ""), \($0.season?.name ?? "")",
                            localTeamImageUrl: $0.localteam?.imagePath ?? "",
                            visitorTeamImageUrl: $0.visitorteam?.imagePath ?? "",
                            tag: tag)
                    })
                    for i in 0...filteredFixtures.count - 1 {
                        let fixtureLocalModel = filteredFixtures[i]
                        NotificationHandler.pushToLocalNotification(model: LocalNotificationModel(id: fixtureLocalModel.id?.description ?? "", title: "\(fixtureLocalModel.localteam?.code ?? "") vs \(fixtureLocalModel.visitorteam?.code ?? "")", subtitle: "", notificationTime: fixtureLocalModel.startingAt ?? ""))
                    }
                    self.isLoading = false
                case .failure(let failure):
                    print("ERROR OCCURRED\(failure)")
                    self.isLoading = false
                    self.error = failure
                }
            }
        } else{
            ServiceHandler.shared.fetchRecentMatchFixture { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let fixtures):
                    
                    guard let fixtures = fixtures else { return }
                    
                    var filteredFixtures: [FixtureModel]
                    
                    switch segmentIdx {
                    case 0:
                        filteredFixtures = fixtures
                    case 1:
                        filteredFixtures = fixtures.filter({
                            ($0.type ?? "") == "Test"
                        })
                    case 2:
                        filteredFixtures = fixtures.filter({
                            (($0.type ?? "") == "T20") || (($0.type ?? "") == "T20I")
                        })
                    default:
                        filteredFixtures = fixtures.filter({
                            ($0.type ?? "") == "ODI"
                        })
                    }
                    self.fixtureModels = filteredFixtures.compactMap({
                        
                        guard let runs = $0.runs, let firstTeamRuns = runs.first else { return MatchCellModel(
                            id: $0.id ?? -1,
                            isLive: false,
                            localTeamCode: $0.localteam?.code ?? "",
                            visitorTeamCode: $0.visitorteam?.code ?? "",
                            localTeamScore: "",
                            visistorTeamScore: "" ,
                            localTeamOver: "",
                            visitorTeamOver: "",
                            matchNote: $0.startingAt ?? "",
                            matchType: "\($0.league?.name ?? ""), \($0.season?.name ?? "")",
                            localTeamImageUrl: $0.localteam?.imagePath ?? "",
                            visitorTeamImageUrl: $0.visitorteam?.imagePath ?? "",
                            tag:tag) }
                        
                        if (runs.count == 1) {
                            return MatchCellModel(
                                id: $0.id ?? -1,
                                isLive: false,
                                localTeamCode: firstTeamRuns.team?.code ?? "",
                                visitorTeamCode: (firstTeamRuns.team?.code ?? "") == ($0.visitorteam?.code ?? "") ? $0.localteam?.code ?? "" : $0.visitorteam?.code ?? "",
                                localTeamScore: "\(firstTeamRuns.score?.description ?? "")/\(firstTeamRuns.wickets?.description ?? "")",
                                visistorTeamScore: "N/A" ,
                                localTeamOver: "\(firstTeamRuns.overs?.description ?? "") Overs",
                                visitorTeamOver: "",
                                matchNote: $0.note ?? "",
                                matchType: "\($0.league?.name ?? ""), \($0.season?.name ?? "")",
                                localTeamImageUrl: firstTeamRuns.team?.imagePath ?? "",
                                visitorTeamImageUrl: (firstTeamRuns.team?.code ?? "") == ($0.visitorteam?.code ?? "") ? $0.localteam?.imagePath ?? "" : $0.visitorteam?.imagePath ?? "",
                                tag: tag)
                        }
                                                return MatchCellModel(
                            id: $0.id ?? -1,
                            isLive: false,
                            localTeamCode: $0.runs?[0].team?.code ?? "",
                            visitorTeamCode: $0.runs?[1].team?.code ?? "",
                            localTeamScore: "\($0.runs?[0].score?.description ?? "")/\($0.runs?[0].wickets?.description ?? "")",
                            visistorTeamScore: "\($0.runs?[1].score?.description ?? "")/\($0.runs?[1].wickets?.description ?? "")" ,
                            localTeamOver: "\($0.runs?[0].overs?.description ?? "") Overs" ,
                            visitorTeamOver: "\($0.runs?[1].overs?.description ?? "") Overs" ,
                            matchNote: $0.note ?? "N/A",
                            matchType: "\($0.league?.name ?? ""), \($0.season?.name ?? "")",
                            localTeamImageUrl: $0.runs?[0].team?.imagePath ?? "",
                            visitorTeamImageUrl: $0.runs?[1].team?.imagePath ?? "",
                            tag: tag)
                    })
                    self.isLoading = false
                case .failure(let failure):
                    print("ERROR OCCURRED\(failure)")
                    self.isLoading = false
                    self.error = failure
                }
            }
        }
    }
    
    func fetchDataByTime(date: Date, finishingDate: Date) {
        isLoading = true
        
//        let endDate = Date().addingTimeInterval(24 * 60 * 60)
        ServiceHandler.shared.fetchAllFixtures(startDate: date.ISO8601Format(), endDate: finishingDate.ISO8601Format(), isAscending: true) {[weak self] results in
            guard let self = self else {
                return
            }
            switch results {
            case .success(let data):
                self.fixtureModels = data?.compactMap({
                    MatchCellModel(
                        id: $0.id ?? -1,
                        isLive: false,
                        localTeamCode: $0.localteam?.code ?? "",
                        visitorTeamCode: $0.visitorteam?.code ?? "",
                        localTeamScore: "",
                        visistorTeamScore: "" ,
                        localTeamOver: "",
                        visitorTeamOver: "",
                        matchNote: $0.startingAt ?? "",
                        matchType: "\($0.league?.name ?? ""), \($0.season?.name ?? "")",
                        localTeamImageUrl: $0.localteam?.imagePath ?? "",
                        visitorTeamImageUrl: $0.visitorteam?.imagePath ?? "",
                        tag: 1)
                }) ?? []
                self.isLoading = false
            case .failure(let error):
                print(error)
            }
        }
    }
}
