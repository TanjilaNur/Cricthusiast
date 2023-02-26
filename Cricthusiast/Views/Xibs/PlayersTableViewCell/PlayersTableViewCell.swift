//
//  PlayersTableViewCell.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/10/23.
//

import UIKit
import SDWebImage

struct PlayerCellModel {
    let id: Int
    let playerName: String
    let playerImageUrl: String
    let playerInfo: String

}




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
        if model.id == -9999 {
            playerImgView.sd_setImage(with: URL(string: model.playerImageUrl), placeholderImage: UIImage(systemName: "bell.fill"), options: .progressiveLoad)
        }
        playerInfoLabel.text = model.playerInfo
    }
    
    func setValuesForTeams(model: TeamDataModel){
        playerNameLabel.text = model.name ?? ""
        playerImgView.sd_setImage(with: URL(string: model.imagePath ?? ""), placeholderImage: UIImage(systemName: "photo"), options: .progressiveLoad)
        playerInfoLabel.text = (model.nationalTeam ?? false) ? "International" : "Domestic"
    }
    
}
