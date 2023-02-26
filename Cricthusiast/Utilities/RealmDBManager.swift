//
//  RealmDBManager.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 18/2/23.
//

import Foundation
import RealmSwift

class RealmDBManager {
    
    static let shared = RealmDBManager()
    var realmDB: Realm!
    
    private init() {
        do {
            realmDB = try Realm()
        } catch {
            print(error)
        }
    }
    
    func addData(players:[PlayerLocalDBModel]) {
        do {
            try realmDB.write {
                realmDB.add(players)
            }
        } catch {
            print(error)
        }
    }
    
    
    func read() -> [PlayerLocalDBModel] {
        let results  = realmDB.objects(PlayerLocalDBModel.self)
        
        var players: [PlayerLocalDBModel] = []
        for result in results {
            players.append(result)
        }
        return players
    }
}
