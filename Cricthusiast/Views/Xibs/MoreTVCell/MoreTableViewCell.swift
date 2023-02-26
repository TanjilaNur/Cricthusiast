//
//  MoreTableViewCell.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/23/23.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
    
    static let id = "MoreTableViewCell"
    
    @IBOutlet weak var rootView: UIView!
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
