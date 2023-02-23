//
//  PlayersTableViewCell.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/10/23.
//

import UIKit
import SDWebImage


class PlayersTableViewCell: UITableViewCell {
    
    static let id = "PlayersTableViewCell"
    
    @IBOutlet weak var playerImgView: UIImageView!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var playerInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        playerImgView.layer.cornerRadius = playerImgView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setValuesForPlayers(model: PlayerCellModel) {
        playerNameLabel.text = model.playerName
        playerImgView.sd_setImage(with: URL(string: model.playerImageUrl), placeholderImage: UIImage(systemName: "photo"), options: .progressiveLoad)
        playerInfoLabel.text = model.playerInfo
    }
    
}
