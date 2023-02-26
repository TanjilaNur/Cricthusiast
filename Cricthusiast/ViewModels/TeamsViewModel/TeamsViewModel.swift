//
//  TeamsViewModel.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/25/23.
//

import Foundation

class TeamsViewModel{
    
    @Published var isLoading = false
    @Published var error: Error?
    
    var teamsDataModels: [TeamDataModel] = []
    var queryTeamDataModels: [TeamDataModel] = []
    
    var teamSquadModel: [PlayerCellModel] = []
    var queryteamSquadModel: [PlayerCellModel] = []
    
    var teamName: String = ""
    
    func fetchTeamsData(){
        isLoading = true
        
        ServiceHandler.shared.fetchAllTeams {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                guard let data = data else { return }
                self.teamsDataModels = data
                
                self.queryTeamDataModels = data
                self.isLoading = false
            case .failure(let error):
                print(error)
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    func searchTeam(query: String){
        isLoading = true
        if !query.isEmpty {
            queryTeamDataModels = teamsDataModels.filter({
                guard let name = $0.name else {return false}
                print(name,name.lowercased().contains(query),query)
                return name.lowercased().contains(query)
            })
        } else {
            queryTeamDataModels = teamsDataModels
        }
        isLoading = false
    }
    
    
    func searchTeamSquadMember(query: String){
        isLoading = true
        if !query.isEmpty {
            queryteamSquadModel = teamSquadModel.filter({
                $0.playerName.lowercased().contains(query.lowercased())
            })
        } else {
            queryTeamDataModels = teamsDataModels
        }
        isLoading = false
    }
    
    func fetchTeamSquad(by id: Int){
        isLoading = true
        
        ServiceHandler.shared.fetchTeamSquad(id: id) {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                guard let squad = data?.squad else { return }
                
                let ids = squad.compactMap {
                    $0.id
                }
                
                let uniqueId = Set(ids)
                
                var uniqueSquadMembers: [SquadElement] = []
                
                for uid in uniqueId {
                    let squadMember = squad.first {
                        $0.id == uid
                    }
                    guard let sMember = squadMember else { continue }
                    uniqueSquadMembers.append(sMember)
                }
                
                
                self.teamSquadModel = uniqueSquadMembers.compactMap({
                    PlayerCellModel(
                        id: $0.id ?? -1,
                        playerName: $0.fullname ?? "",
                        playerImageUrl: $0.imagePath ?? "",
                        playerInfo: $0.position?.name ?? "")
                })
                
                self.queryteamSquadModel = self.teamSquadModel
                self.isLoading = false
            case .failure(let error):
                print(error)
                self.error = error
                self.isLoading = false
            }
        }
    }
}
