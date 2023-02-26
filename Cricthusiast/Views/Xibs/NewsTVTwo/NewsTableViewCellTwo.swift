//
//  NewsTableViewCellTwo.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/25/23.
//

import UIKit

class NewsTableViewCellTwo: UITableViewCell {
    
    static let id = "NewsTableViewCellTwo"

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var pubTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
