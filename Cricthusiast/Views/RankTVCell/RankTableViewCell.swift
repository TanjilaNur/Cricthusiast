//
//  RankTableViewCell.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/23/23.
//

import UIKit

struct RankTVCellModel{
    let rank: Int
    let country: String
    let countryFlagUrl: String
    let matchCount: Int
    let Rating: Int
    let points: Int
}

class RankTableViewCell: UITableViewCell {
    
    static let id = "RankTableViewCell"
    
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var matchesLabel: UILabel!
    
    @IBOutlet weak var ratingLable: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var flagImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(model: RankTVCellModel) {
        rankLabel.text = model.rank.description
        countryLabel.text = model.country
        flagImage.sd_setImage(with: URL(string: model.countryFlagUrl), placeholderImage: UIImage(systemName: "photo") , options: .progressiveLoad)
        
        matchesLabel.text = "Matches: \(model.matchCount.description)"
        ratingLable.text = model.Rating.description
        pointsLabel.text = model.points.description
    }
    
}
