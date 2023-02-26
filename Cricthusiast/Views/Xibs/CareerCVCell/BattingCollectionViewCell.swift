//
//  BattingCollectionViewCell.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/22/23.
//

import UIKit

struct PlayerBattingCareerModel {
    let title: String
    let matches: String
    let season: String
    let innings: String
    let score: String
    let highestInningScore: String
    let strikeRate: String
    let ballsFaced: String
    let average: String
    let six_x: String
    let four_x: String
    let hundreds: String
    let fifties: String
    let fowScore: String
}

struct PlayerBowlingCareerModel {
    let title: String
    let matches: String
    let season: String
    let overs: String
    let innings: String
    let average: String
    let econRate: String
    let medians: String
    let runs: String
    let wickets: String
    let wide: String
    let noBall: String
    let strikeRate: String
    let rate: String
}

class BattingCollectionViewCell: UICollectionViewCell {
    
    static let id = "BattingCollectionViewCell"
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet var matchInfoLabels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 20
        bgView.layer.masksToBounds = true
        
        for label in matchInfoLabels{
            label.layer.cornerRadius = 10
            label.layer.masksToBounds = true
        }
        
        print(matchInfoLabels.count)
    }
    
    func setBattingData(data: PlayerBattingCareerModel) {
        matchInfoLabels[0].text = "\(data.title) - \(data.season)"
        matchInfoLabels[1].text = data.matches
        matchInfoLabels[2].text = data.innings
        matchInfoLabels[3].text = data.score
        matchInfoLabels[4].text = data.highestInningScore
        matchInfoLabels[5].text = data.strikeRate
        matchInfoLabels[6].text = data.ballsFaced
        matchInfoLabels[7].text = data.average
        matchInfoLabels[8].text = data.six_x
        matchInfoLabels[9].text = data.four_x
        matchInfoLabels[10].text = data.hundreds
        matchInfoLabels[11].text = data.fifties
        matchInfoLabels[12].text = data.fowScore
    }
    
    func setBowlingData(data: PlayerBowlingCareerModel) {
        matchInfoLabels[0].text = "\(data.title) - \(data.season)"
        matchInfoLabels[1].text = data.matches
        matchInfoLabels[2].text = data.overs
        matchInfoLabels[3].text = data.innings
        matchInfoLabels[4].text = data.average
        matchInfoLabels[5].text = data.econRate
        matchInfoLabels[6].text = data.medians
        matchInfoLabels[7].text = data.runs
        matchInfoLabels[8].text = data.wickets
        matchInfoLabels[9].text = data.wide
        matchInfoLabels[10].text = data.noBall
        matchInfoLabels[11].text = data.strikeRate
        matchInfoLabels[12].text = data.rate
    }
}
