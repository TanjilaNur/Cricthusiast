//
//  UpcomingViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 3/2/23.
//

import UIKit
import Combine

class SubVCIdConstants {
    static let infoVCid = "MatchInfoViewController"
    static let scoreboardVCid = "MatchScorecardViewController"
    static let overVCid =  "MatchOversViewController"
    static let squadsVCid = "MatchSquadsViewController"
}

class MatchDetailsViewController: UIViewController {
    @IBOutlet weak var ltCCLabel: UILabel!
    @IBOutlet weak var ltScoreLabel: UILabel!
    @IBOutlet weak var ltFlagImage: UIImageView!
    @IBOutlet weak var ltOverLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var vtFlagImage: UIImageView!
    @IBOutlet weak var vtCCLabel: UILabel!
    @IBOutlet weak var vtScoreLabel: UILabel!
    @IBOutlet weak var vtOverLabel: UILabel!
    @IBOutlet weak var bgVenueImage: UIImageView!
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerVCView: UIView!
    @IBOutlet var containerTabButtons: [UIButton]!
    
    var id: Int!
    var selectedMatchId: Int?

    let viewModel = MatchDetailsViewModel()
    var cancellables: Set<AnyCancellable> = []
   // var status
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinder()
        contentView.layer.cornerRadius = 20
        initiateVcWith(tag: 0)
        viewModel.getMatchInfo(id: id!)
    }
    
    func setSelectedVC(_ selectedVC: UIViewController) {
        addChild(selectedVC)
        selectedVC.view.frame = containerVCView.bounds
        containerVCView.addSubview(selectedVC.view)
        selectedVC.didMove(toParent: self)
    }
    
    @IBAction func tabButtonTapped(_ sender: UIButton) {
        initiateVcWith(tag: sender.tag)
    }
    
    func setUpBinder(){
        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isLoading {
                    print("a")
                } else {                    
                    self.ltFlagImage.sd_setImage(with: URL(string: self.viewModel.ltFlagUrl ?? ""), placeholderImage: UIImage(systemName: "photo"), options: .progressiveLoad)
                    self.vtFlagImage.sd_setImage(with: URL(string: self.viewModel.vtFlagUrl ?? ""), placeholderImage: UIImage(systemName: "photo"), options: .progressiveLoad)
                    
                    self.ltCCLabel.text = self.viewModel.ltCCode
                    self.vtCCLabel.text = self.viewModel.vtCCode
                    
                    if let ltScore = self.viewModel.ltScore, let ltWickets = self.viewModel.ltWickets {
                        self.ltScoreLabel.text = "\(ltScore)/\(ltWickets)"
                    }
                    if let vtScore = self.viewModel.vtScore, let vtWickets = self.viewModel.vtWickets {
                        self.vtScoreLabel.text = "\(vtScore)/\(vtWickets)"
                    }
                   
                    
                    let ltOver = self.viewModel.ltOver
                    let vtOver = self.viewModel.vtOver
                    self.ltOverLabel.text = "\((ltOver?.isEmpty ?? true) ? "":"\(ltOver ?? "") Overs")"
                    self.vtOverLabel.text = "\((vtOver?.isEmpty ?? true) ? "":"\(vtOver ?? "") Overs")"
                    
                    self.noteLabel.text = self.viewModel.matchNote
                }
            }
        }.store(in: &cancellables)
    }
    
    
    
    
    func initiateVcWith(tag: Int){
        let storyboard = UIStoryboard(name: "Matches", bundle: nil)
        
        let infoVC = storyboard.instantiateViewController(withIdentifier: SubVCIdConstants.infoVCid)
        let scorecardVC = storyboard.instantiateViewController(withIdentifier: SubVCIdConstants.scoreboardVCid)
        let squadVC = storyboard.instantiateViewController(withIdentifier: SubVCIdConstants.squadsVCid)
        
        let selectedVC: UIViewController
        
        for button in containerTabButtons {
            if button.tag == tag {
                button.alpha = 1
            } else {
                button.alpha = 0.6
            }
        }
        
        switch tag {
        case 0:
            // INFO
            selectedVC = infoVC
        case 1:
            // Scorecard
            selectedVC = scorecardVC
            
        default:
            // SQUADS
            selectedVC = squadVC
        }
        setSelectedVC(selectedVC)
    }
  
}


