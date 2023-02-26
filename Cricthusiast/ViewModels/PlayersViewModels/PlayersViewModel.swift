//
//  PlayersViewModel.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/13/23.
//

import Foundation

struct PlayerCellDetailsModel {
    let id: Int
    let playerCountry: String
    let playerName: Bool
    let playerImageURL: String
    let playerDoB: String
    let playerGender: String
    let playerBattingStyle: String
    let playerBowlingStyle: String
    let playerPosition: String
}

class PlayersViewModel {
    @Published var playerList: [PlayerCellModel] = []
    
    @Published var isFetchingCompleted: Bool = false
    
    @Published var error: Error?
    
    
    func fetchPlayersData() {
        isFetchingCompleted = false
        
        let playersFromDatabase = RealmDBManager.shared.read()
        
        if playersFromDatabase.isEmpty {
            
            ServiceHandler.shared.fetchAllPlayers {[weak self] res in
                
                guard let self = self else { return }
                
                switch res {
                case .success(let data):
                    guard let allPlayers = data else { return }
                    
                    var playersLocalDB: [PlayerLocalDBModel] = []
                    
                    for player in allPlayers {
                        let playerLocalDB = PlayerLocalDBModel()
                        playerLocalDB.id = player.id ?? -1
                        playerLocalDB.name = player.fullname
                        playerLocalDB.imageUrl = player.imagePath
                        playerLocalDB.country = player.country?.name
                        playersLocalDB.append(playerLocalDB)
                    }
                    
                    RealmDBManager.shared.addData(players: playersLocalDB)
                    
                    self.playerList = playersLocalDB.compactMap({
                        PlayerCellModel(id: $0.id, playerName: $0.name ?? "", playerImageUrl: $0.imageUrl ?? "", playerInfo: $0.country ?? "")
                    })
                    self.isFetchingCompleted = true
                    print("COMPLETED")
                case .failure(let error):
                    print(error)
                    self.isFetchingCompleted = true
                    self.error = error
                }
            }
        } else {
            playerList = playersFromDatabase.compactMap({
                PlayerCellModel(id: $0.id, playerName: $0.name ?? "", playerImageUrl: $0.imageUrl ?? "", playerInfo: $0.country ?? "")
            })
            self.isFetchingCompleted = true
            print("FROM DB COMPLETED")
        }
    }

    func searchPlayer(query: String){
        self.isFetchingCompleted = false
        var predicate = NSPredicate(value: true)
        if !(query.isEmpty) {
             predicate = NSPredicate(format: "name CONTAINS[cd] %@",query)
        }
        let queryResults = RealmDBManager.shared.realmDB.objects(PlayerLocalDBModel.self).filter(predicate)
        
        playerList = queryResults.compactMap({
            PlayerCellModel(id: $0.id, playerName: $0.name ?? "", playerImageUrl: $0.imageUrl ?? "", playerInfo: $0.country ?? "")
        })
        
        self.isFetchingCompleted = true
    }
    
}
