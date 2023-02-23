//
//  PlayerInfoCVCell.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/22/23.
//

import UIKit

class PlayerInfoCVCell: UICollectionViewCell {
    static let id = "PlayerInfoCVCell"
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.layer.cornerRadius = 10
        titleLabel.layer.masksToBounds = true
        
    }
}

