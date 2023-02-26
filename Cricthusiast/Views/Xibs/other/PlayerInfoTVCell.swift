//
//  PlayerInfoTVCell.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/18/23.
//

import UIKit

struct PlayerInfoTVCellModel{
    let title: String
    let info: String
}

class PlayerInfoTVCell: UITableViewCell {
    
    static let id = "PlayerInfoTVCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setInfoCellModel(model: PlayerInfoTVCellModel) {
        titleLabel.text = model.title
        infoLabel.text = model.info
    }
}
