//
//  ScoreCardTVCell.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/16/23.
//

import UIKit

struct ScoreTableViewCellModel {
    let playerTeamName: String
    let playerId: Int
    let playerImageUrl: String
    let playerName: String
    let playerOutNote: String
    let stackInfos: [String?]
}

class ScoreCardTVCell: UITableViewCell {
    
    static let id = "ScoreCardTVCell"
    
    @IBOutlet weak var playerImageView: UIImageView!
    
    @IBOutlet weak var rootView: UIView!
    
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var playerScore: UILabel!
    
    @IBOutlet var stackScoreInfo: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        rootView.layer.cornerRadius = 10
        playerImageView.layer.cornerRadius = playerImageView.frame.height / 2
    }
    
    func setValuesForScorecard(model: ScoreTableViewCellModel) {
        playerImageView.sd_setImage(with: URL(string: model.playerImageUrl), placeholderImage: UIImage(named: "placeholder"),options: .progressiveLoad)
        playerName.text = model.playerName
        playerScore.text = model.playerOutNote
        
        for i in (0..<stackScoreInfo.count) {
            stackScoreInfo[i].text = model.stackInfos[i] ?? "N/A"
        }
    }
}
