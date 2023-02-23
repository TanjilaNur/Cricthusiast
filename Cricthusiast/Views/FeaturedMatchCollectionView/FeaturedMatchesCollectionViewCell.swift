//
//  CollectionViewCollectionViewCell.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/10/23.
//

import UIKit
import SDWebImage



class FeaturedMatchesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!

    @IBOutlet weak var liveSignView: UIView!
    
    
    @IBOutlet weak var matchTitleLabel: UILabel!
    
    @IBOutlet weak var localTeamImage: UIImageView!
    
    @IBOutlet weak var visitorTeamImage: UIImageView!
    
    @IBOutlet weak var localTeamNameLabel: UILabel!
    
    @IBOutlet weak var visitorTeamNameLabel: UILabel!
    
    @IBOutlet weak var localTeamScoreLabel: UILabel!
    
    @IBOutlet weak var visitorTeamScoreLabel: UILabel!
    
    @IBOutlet weak var localTeamOver: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var matchTypeBGView: UIView!
    
    @IBOutlet weak var visitorTeamOver: UILabel!
    
    var upcomingMatchTimer: Timer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        localTeamImage.layer.cornerRadius = localTeamImage.frame.height / 2
        matchTypeBGView.layer.cornerRadius = 10
        
        localTeamImage.layer.shadowColor = UIColor.gray.cgColor
        localTeamImage.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        localTeamImage.layer.shadowRadius = 25.0
        localTeamImage.layer.shadowOpacity = 1
        
        visitorTeamImage.layer.cornerRadius = visitorTeamImage.frame.height / 2
    }
    
    func setValues(model: MatchCellModel, tag: Int) {
        
        if tag==0{
            liveSignView.layer.opacity = 1
        } else{
            liveSignView.layer.opacity = 0
        }
        
        if tag == 1 {
            noteLabel.text = formatTime(from: model.matchNote)
            startCountingDown(time: model.matchNote)
        } else {
            noteLabel.text = model.matchNote
        }
        matchTitleLabel.text = model.matchType
        
        localTeamImage.sd_setImage(with: URL(string: model.localTeamImageUrl), placeholderImage: nil, options: [.progressiveLoad])
        localTeamNameLabel.text = model.localTeamCode
        localTeamOver.text = model.localTeamOver
        localTeamScoreLabel.text = model.localTeamScore
        visitorTeamImage.sd_setImage(with: URL(string: model.visitorTeamImageUrl), placeholderImage: nil, options: [.progressiveLoad])
        visitorTeamNameLabel.text = model.visitorTeamCode
        visitorTeamOver.text = model.visitorTeamOver
        visitorTeamScoreLabel.text = model.visistorTeamScore
                
    }
    
    func startCountingDown(time: String) {
        upcomingMatchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] timer in
            
            guard let self = self else {
                return
            }
            self.updateCountDown(time: time)
            
        }
    }
    
    func updateCountDown(time: String) {
        let timeDifference = findTimeDifference(from: time)
        noteLabel.text = findFormattedTimeInDC(from: timeDifference)
        guard let timeDifference = timeDifference
        else {
            upcomingMatchTimer?.invalidate()
            upcomingMatchTimer = nil
            return
        }
        
        if let date = Calendar.current.date(from: timeDifference) {
            let timeInterval = date.timeIntervalSince1970
            print("Time interval: \(timeInterval) seconds")
            if timeInterval == 0 {
                stopCountingDown()
            }
        }

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopCountingDown()
    }
    
    func stopCountingDown(){
        upcomingMatchTimer?.invalidate()
        upcomingMatchTimer = nil
    }
    

}
