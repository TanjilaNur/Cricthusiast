//
//  PlayerCollectionViewCell.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/14/23.
//

import UIKit

struct SquadCollectionViewCellModel {
    let playerId: Int
    let playerName: String
    let playerImageUrl: String
    let playerPosition: String
    
    let isCaptain: Bool
    let isWicketKeeper: Bool
}


class SquadCollectionViewCell: UICollectionViewCell {
    
    static let id = "SquadCollectionViewCell"
    
    @IBOutlet weak var leadingRootView: UIView!
    
    @IBOutlet weak var trailingRootView: UIView!
    
    @IBOutlet weak var leadingPlayerImage: UIImageView!
    
    @IBOutlet weak var leadingPlayerNameLabel: UILabel!
    
    @IBOutlet weak var leadingInfoLabel: UILabel!
    
    @IBOutlet weak var trailingPlayerImage: UIImageView!
    
    @IBOutlet weak var trailingPlayerNameLabel: UILabel!
    
    @IBOutlet weak var trailingInfoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leadingPlayerImage.layer.cornerRadius = leadingPlayerImage.frame.height / 2
        trailingPlayerImage.layer.cornerRadius = trailingPlayerImage.frame.height / 2
    }
    
    func setSquadCVCellValues(model: SquadCollectionViewCellModel, index: Int) {
        
        if index % 2 == 0 {
            trailingRootView.layer.opacity = 0
            leadingPlayerNameLabel.text = model.playerName
            leadingInfoLabel.text = model.playerPosition
            leadingPlayerImage.sd_setImage(with: URL(string: model.playerImageUrl),placeholderImage: UIImage(named: "placeholder"), options: .progressiveLoad)
            leadingRootView.layer.opacity = 1
        } else {
            leadingRootView.layer.opacity = 0
            trailingPlayerNameLabel.text = model.playerName
            trailingInfoLabel.text = model.playerPosition
            trailingPlayerImage.sd_setImage(with: URL(string: model.playerImageUrl),placeholderImage: UIImage(named: "placeholder"), options: .progressiveLoad)
            trailingRootView.layer.opacity = 1
        }
    }
    

}
