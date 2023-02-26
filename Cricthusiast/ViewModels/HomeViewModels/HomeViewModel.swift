//
//  MainViewModel.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 3/2/23.
//

import Foundation


class HomeViewModel {
    @Published var isRecentLoading = false
    @Published var isUpcomingLoading = false
    @Published var isLiveLoading = false
    
    @Published var isNewsLoading = false
    
    @Published var error: Error?
    
    var recentMatches: [MatchCellModel] = []
    var upcomingMatches: [MatchCellModel] = []
    var liveMatches: [MatchCellModel] = []
    
    var twoUpcoming: [MatchCellModel] = []
    var threeRecent: [MatchCellModel] = []
    var featuredMatches:[MatchCellModel] = []
    
    var articles: [ArticleModel] = []
    
    var notificationModel:[PlayerCellModel] = []
    
    @Published var isLoading = false
    
    func fetchFeaturedFixture() {
        isUpcomingLoading = true
        isRecentLoading = true

        
        ServiceHandler.shared.fetchUpcomingMatchFixture {[weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let data = data else { return }
                self.upcomingMatches = data.compactMap({
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
                })
                self.twoUpcoming = []
                if (self.upcomingMatches.count >= 2){
                    self.twoUpcoming.append(self.upcomingMatches.removeFirst())
                    self.twoUpcoming.append(self.upcomingMatches.removeFirst())
                } else {
                    self.twoUpcoming = self.upcomingMatches
                }
                self.isUpcomingLoading = false
            case .failure(let failure):
                print(failure)
                self.error = failure
                self.isUpcomingLoading = false
            }
        }
        
        ServiceHandler.shared.fetchRecentMatchFixture {[weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                guard let data = data else { return }
                self.recentMatches = data.compactMap({
                    guard let runs = $0.runs, let firstTeamRuns = runs.first else { return MatchCellModel(
                        id: $0.id ?? -1,
                        isLive: false,
                        localTeamCode: $0.localteam?.code ?? "",
                        visitorTeamCode: $0.visitorteam?.code ?? "",
                        localTeamScore: "N/A",
                        visistorTeamScore: "N/A" ,
                        localTeamOver: "",
                        visitorTeamOver: "",
                        matchNote: $0.note ?? "",
                        matchType: "\($0.league?.name ?? ""), \($0.season?.name ?? "")",
                        localTeamImageUrl: $0.localteam?.imagePath ?? "",
                        visitorTeamImageUrl: $0.visitorteam?.imagePath ?? "",
                        tag: 2) }
                    
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
                            tag: 2)
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
                        tag: 2)
                })
                self.threeRecent = []
                if (self.recentMatches.count >= 2){
                    self.threeRecent.append(self.recentMatches.removeFirst())
                    self.threeRecent.append(self.recentMatches.removeFirst())
                    self.threeRecent.append(self.recentMatches.removeFirst())
                } else {
                    self.threeRecent = self.recentMatches
                }
                self.isRecentLoading = false
            case .failure(let failure):
                print(failure)
                self.isRecentLoading = false
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {[weak self] timer in
            guard let self = self else { return }

            self.isLiveLoading = true
            ServiceHandler.shared.fetchLiveMatch {[weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    guard let data = data else { return }
                    self.liveMatches = data.compactMap({
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
                                tag: 0)
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
                            tag: 0)
                    })
                    self.isLiveLoading = false
                case .failure(let failure):
                    print(failure)
                    
                    self.isLiveLoading = false
                }
            }
        }
    }
    
    func getAllAddedNotification() {
        isLoading = true
        NotificationHandler.getAllPendingNotification {[weak self] notifications in
            guard let self = self else { return }
            
            self.notificationModel = notifications.compactMap({
                PlayerCellModel(id: -9999, playerName: $0.title, playerImageUrl: "", playerInfo: $0.notificationTime)
            })
            
            self.isLoading = true
            
        }
    }
    
    func getHomePageData(){
        fetchFeaturedFixture()
        fetchNewses()
    }
    
    func fetchNewses(){
        isNewsLoading = true
        ServiceHandler.shared.fetchAllNews {[weak self] results in
            guard let self = self else { return }
            switch results {
            case .success(let data):
                guard let data = data else { return }
                self.articles = data
                self.isNewsLoading = false
            case .failure(let error):
                print(error)
                self.isNewsLoading = false
            }
        }
    }
    
}
