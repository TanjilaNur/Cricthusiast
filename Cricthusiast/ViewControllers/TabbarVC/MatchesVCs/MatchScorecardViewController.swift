//
//  MatchScorecardViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/14/23.
//

import UIKit
import Combine

class MatchScorecardViewController: UIViewController {
    
    @IBOutlet weak var mnsyImage: UIImageView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scSegmentControl: UISegmentedControl!
    
    
    let battingScoreTitles = ["R","B","4S","6s","SR"]
    let bowlingScoreTitles = ["O","M","R","W","ER"]
    
    var cancellables: Set<AnyCancellable> = []
    var ltScoreTVCellModels : [[ScoreTableViewCellModel]] = []
    var vtScoreTVCellModels : [[ScoreTableViewCellModel]] = []
    let viewModel = MatchDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionHeaderTopPadding = 0
        setUpBinder()
        let parentVC = parent as! MatchDetailsViewController
        viewModel.fetchScoreCardInfo(id: parentVC.id)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: ScoreCardTVCell.id, bundle: nil), forCellReuseIdentifier: ScoreCardTVCell.id)
        tableView.register(UINib(nibName: ScoreTableSectionHeader.id, bundle: nil), forHeaderFooterViewReuseIdentifier: ScoreTableSectionHeader.id)
        
    }
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    func autoRefreshApp() {
        let currentDate = Date()
        let lastUpdatedTime:Int64 = UserDefaults.standard.value(forKey: "lastUpdateTime") as? Int64 ?? 0
        let currentTime = Int64(currentDate.timeIntervalSince1970 * 1000)
        let dateDiffrence = currentTime - lastUpdatedTime
        
        if dateDiffrence >= 1*60*60*1000 {
            let id = (parent as! MatchDetailsViewController).id
            self.viewModel.fetchScoreCardInfo(id: id ?? -1)
            UserDefaults.standard.setValue(currentTime, forKey: "lastUpdateTime")
        }
    }
    
    
    func setUpBinder() {
        viewModel.$ltScoreTVCellModels.sink {[weak self] localTeamScores in
            guard let self = self else { return }
            
            self.ltScoreTVCellModels = localTeamScores
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }.store(in: &cancellables)
        
        viewModel.$vtScoreTVCellModels.sink {[weak self] visitorTeamScores in
            guard let self = self else { return }
            
            self.vtScoreTVCellModels = visitorTeamScores
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }.store(in: &cancellables)
        
        viewModel.$isRecent.sink {[weak self] isRecent in
            guard let self = self, let isRecent = isRecent else {
                return
            }
            
            if (!isRecent) {
                self.tableView.layer.opacity = 0
            } else {
                self.tableView.layer.opacity = 1
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.tableView.alpha = 0
                    self.mnsyImage.alpha = 0
                    self.loadingIndicator.startAnimating()
                } else {
                    self.loadingIndicator.stopAnimating()
                    self.mnsyImage.alpha = 1
                    if self.ltScoreTVCellModels.isEmpty && self.vtScoreTVCellModels.isEmpty {
                        self.tableView.alpha = 0
                    } else {
                        self.tableView.alpha = 1
                        self.scSegmentControl.setTitle(self.viewModel.teamNames.first, forSegmentAt: 0)
                        self.scSegmentControl.setTitle(self.viewModel.teamNames.last, forSegmentAt: 1)
                    }
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
                    let parentVC = self.parent as? MatchDetailsViewController
                    self.viewModel.getMatchInfo(id: parentVC?.id ?? -1)
                }

                alertController.addAction(okayAction)
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true)
            }
        }.store(in: &cancellables)
    }

}

extension MatchScorecardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ScoreTableSectionHeader.id) as! ScoreTableSectionHeader
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true

        if section == 0 {
            cell.sectionTitle.text = "Batting"
            for i in 0..<5{
                cell.scoreStackTitles[i].text = battingScoreTitles[i]
            }
        } else {
            cell.sectionTitle.text = "Bowling"
            for i in 0..<5{
                cell.scoreStackTitles[i].text = bowlingScoreTitles[i]
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if scSegmentControl.selectedSegmentIndex == 0{
            return ltScoreTVCellModels.count
        } else {
            return vtScoreTVCellModels.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scSegmentControl.selectedSegmentIndex == 0{
            if (section == 0) {
                return ltScoreTVCellModels[0].count
            } else {
                return ltScoreTVCellModels[1].count
            }
        } else {
            if (section == 0) {
                return vtScoreTVCellModels[0].count
            } else {
                return vtScoreTVCellModels[1].count
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoreCardTVCell.id, for: indexPath) as! ScoreCardTVCell
        let model: ScoreTableViewCellModel
         
        if scSegmentControl.selectedSegmentIndex == 0{
            if (indexPath.section == 0) {
                model = ltScoreTVCellModels[0][indexPath.row]
            } else {
                model = ltScoreTVCellModels[1][indexPath.row]
            }
        } else {
            if (indexPath.section == 0) {
                model = vtScoreTVCellModels[0][indexPath.row]
            } else {
                model = vtScoreTVCellModels[1][indexPath.row]
            }
        }
        cell.contentView.layer.cornerRadius = 10
        cell.setValuesForScorecard(model: model)
        
        return cell
    }

}

extension MatchScorecardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.3, delay: 0.1 * Double(indexPath.row)/4, options: [.curveEaseInOut], animations: {
            cell.alpha = 1
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let playerDetailsVC = RouteManagerFactory.shared.routes[RouteConstants.playerDetailsViewControllerId] as? PlayerDetailsViewController else { return }
        
        if scSegmentControl.selectedSegmentIndex == 0{
            if (indexPath.section == 0) {
                playerDetailsVC.id = ltScoreTVCellModels[0][indexPath.row].playerId
            } else {
                playerDetailsVC.id = ltScoreTVCellModels[1][indexPath.row].playerId
            }
        } else {
            if (indexPath.section == 0) {
                playerDetailsVC.id = vtScoreTVCellModels[0][indexPath.row].playerId
            } else {
                playerDetailsVC.id = vtScoreTVCellModels[1][indexPath.row].playerId
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(playerDetailsVC, animated: true)
    }
}


