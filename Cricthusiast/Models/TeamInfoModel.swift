//
//  TeamModels.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/25/23.
//

import Foundation

// MARK: - TeamInfoDataModel
class TeamsInfoDataModel: Codable {
    let data: TeamDataModel?

    init(data: TeamDataModel?) {
        self.data = data
    }
}
