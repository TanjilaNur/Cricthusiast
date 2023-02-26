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
    
    var bellButton: UIBarButtonItem!
    
    var id: Int!
    var selectedMatchId: Int?

    let viewModel = MatchDetailsViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinder()
        contentView.layer.cornerRadius = 20
        initiateVcWith(tag: 0)
        viewModel.getMatchInfo(id: id!)
        
        bellButton = UIBarButtonItem(image: UIImage(systemName: "bell.badge"), style: .plain, target: self, action: #selector(bellButtonTapped))
                
        bellButton.isHidden = false
        navigationItem.rightBarButtonItem = bellButton
    }
    func autoRefreshApp() {
        let currentDate = Date()
        let lastUpdatedTime:Int64 = UserDefaults.standard.value(forKey: "lastUpdateTime") as? Int64 ?? 0
        let currentTime = Int64(currentDate.timeIntervalSince1970 * 1000)
        let dateDiffrence = currentTime - lastUpdatedTime
        
        if dateDiffrence >= 1*60*60*1000 {
            self.viewModel.getMatchInfo(id: id ?? -1)
            UserDefaults.standard.setValue(currentTime, forKey: "lastUpdateTime")
        }
    }
    
    @objc func bellButtonTapped(){
        NotificationHandler.pushToLocalNotification(model: LocalNotificationModel(id: id.description, title: "\(ltCCLabel.text ?? "N/A") vs \(vtCCLabel.text ?? "N/A")", subtitle: "Live match is going to start soon", notificationTime: viewModel.startTime ?? ""))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
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
                        self.ltScoreLabel.text = "\(ltScore)\(ltWickets)"
                    }
                    if let vtScore = self.viewModel.vtScore, let vtWickets = self.viewModel.vtWickets {
                        self.vtScoreLabel.text = "\(vtScore)\(vtWickets)"
                    }
                    
                    let ltOver = self.viewModel.ltOver
                    let vtOver = self.viewModel.vtOver
                    self.ltOverLabel.text = "\((ltOver?.isEmpty ?? true) ? "":"\(ltOver ?? "") Overs")"
                    self.vtOverLabel.text = "\((vtOver?.isEmpty ?? true) ? "":"\(vtOver ?? "") Overs")"
                    
                    self.noteLabel.text = self.viewModel.matchNote
                    
                    print(self.viewModel.startTime)
                }
            }
        }.store(in: &cancellables)
        
        viewModel.$error.sink {[weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            DispatchQueue.main.async {
                print(error)
                let alertController = UIAlertController(title: "Something went wrong!", message: "Please check your interenet connection or try again later.", preferredStyle: .alert)

                let okayAction = UIAlertAction(title: "OK!", style: .default)

                let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { [weak self]_ in
                    guard let self = self else { return }
                    self.viewModel.getMatchInfo(id: self.id!)
                }

                alertController.addAction(okayAction)
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true)
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


