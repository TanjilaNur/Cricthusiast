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
}

class MatchViewModel{
    
    @Published var fixtureModels: [MatchCellModel] = []
    
    func fetchData(tag: Int) {
        
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
                            visitorTeamImageUrl: $0.visitorteam?.imagePath ?? "") }
                        
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
                                visitorTeamImageUrl: (firstTeamRuns.team?.code ?? "") == ($0.visitorteam?.code ?? "") ? $0.localteam?.imagePath ?? "" : $0.visitorteam?.imagePath ?? "")
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
                            visitorTeamImageUrl: secondTeamRuns.team?.imagePath ?? "")
                    })
                case .failure(let failure):
                    print("ERROR OCCURRED\(failure)")
                }
            }
        }
        else if tag == 1{
            ServiceHandler.shared.fetchUpcomingMatchFixture { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let fixtures):
                    guard let fixtures = fixtures else { return }
                    
                    self.fixtureModels = fixtures.compactMap({
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
                            visitorTeamImageUrl: $0.visitorteam?.imagePath ?? "")
                    })
                case .failure(let failure):
                    print("ERROR OCCURRED\(failure)")
                }
            }
        } else{
            ServiceHandler.shared.fetchRecentMatchFixture { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let fixtures):
                    
                    guard let fixtures = fixtures else { return }
                    self.fixtureModels = fixtures.compactMap({
                        MatchCellModel(
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
                            visitorTeamImageUrl: $0.runs?[1].team?.imagePath ?? "")
                        
                    })
                case .failure(let failure):
                    print("ERROR OCCURRED\(failure)")
                }
            }
        }
    }
    
    
}
