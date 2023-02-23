//
//  PlayerLocalDBModel.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 18/2/23.
//

import Foundation
import RealmSwift

class PlayerLocalDBModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String?
    @objc dynamic var country: String?
    @objc dynamic var imageUrl: String?
}
