//
//  AboutInfoTableViewCell.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/15/23.
//

import UIKit

class AboutInfoTableViewCell: UITableViewCell {
    
    static let id = "AboutInfoTableViewCell"

    @IBOutlet weak var leagueImageView: UIImageView!
    
    @IBOutlet weak var leagueName: UILabel!
    
    @IBOutlet weak var season: UILabel!
    
    @IBOutlet weak var round: UILabel!
    
    @IBOutlet weak var matchType: UILabel!
    
    @IBOutlet weak var timeStamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        leagueImageView.layer.cornerRadius = leagueImageView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func setModelValues(model: MatchInfoTVCellModel){
        leagueName.text = model.leagueName
        season.text = "Season: \(model.season)"
        round.text = "Round: \(model.round)"
        matchType.text = "Type: \(model.matchType)"
        timeStamp.text = "Time: \(model.timeStamp)"
        leagueImageView.sd_setImage(with: URL(string: model.leagueImgUrl), placeholderImage: UIImage(systemName: "photo"), options: .progressiveLoad)
    }
    
    func setModelValuesForVenue(model: MatchInfoTVCellModel){
        leagueImageView.sd_setImage(with: URL(string: model.venueImage), placeholderImage: UIImage(named: "bg") , options: .progressiveLoad)
        leagueName.text = model.venueStadium
        season.text = model.venueCity
        round.text = "Capacity: \(model.venueCapacity)"
    }
    
}
