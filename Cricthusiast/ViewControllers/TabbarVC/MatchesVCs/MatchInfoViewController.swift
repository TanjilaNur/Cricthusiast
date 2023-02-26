//
//  MatchInfoViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/14/23.
//

import UIKit
import Combine



class MatchInfoViewController: UIViewController {
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = MatchDetailsViewModel()
    var cancellables: Set<AnyCancellable> = []
    var fixtureModel: MatchInfoTVCellModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinder()
        //        tableView.sectionHeaderTopPadding = 0
        tableView.dataSource = self
        tableView.delegate = self

        
        tableView.register(UINib(nibName: AboutInfoTableViewCell.id, bundle: nil), forCellReuseIdentifier: AboutInfoTableViewCell.id)
        tableView.register(UINib(nibName: GenInfoTableViewCell.id, bundle: nil), forCellReuseIdentifier: GenInfoTableViewCell.id)
        tableView.register(UINib(nibName: PlayersTableViewCell.id, bundle: nil), forCellReuseIdentifier: PlayersTableViewCell.id)
        
        
        let id = (parent as! MatchDetailsViewController).id
        self.viewModel.getMatchInfo(id: id!)
    }
    func autoRefreshApp() {
        let currentDate = Date()
        let lastUpdatedTime:Int64 = UserDefaults.standard.value(forKey: "lastUpdateTime") as? Int64 ?? 0
        let currentTime = Int64(currentDate.timeIntervalSince1970 * 1000)
        let dateDiffrence = currentTime - lastUpdatedTime
        
        if dateDiffrence >= 1*60*60*1000 {
            let id = (parent as! MatchDetailsViewController).id
            self.viewModel.getMatchInfo(id: id ?? -1)
            UserDefaults.standard.setValue(currentTime, forKey: "lastUpdateTime")
        }
    }
    
    func setUpBinder(){
        viewModel.$matchInfoTVCellModel.sink { [weak self] fixtureModel in
            
            guard let self = self else { return }
            let parentVC = self.parent as? MatchDetailsViewController
            guard let fixtureModel = fixtureModel else {
                parentVC?.title = ""
                return
                
            }
            
            self.fixtureModel = fixtureModel
            DispatchQueue.main.async {
                parentVC?.bgVenueImage.sd_setImage(with: URL(string: fixtureModel.venueImage), placeholderImage: UIImage(named: "bg"), options: .progressiveLoad)
                parentVC?.title = "\(fixtureModel.leagueName), \(fixtureModel.season)"
                if (fixtureModel.status == Status.ns.rawValue) {
                    parentVC?.ltScoreLabel.text = ""
                    parentVC?.vtScoreLabel.text = ""
                }
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.tableView.alpha = 0
                    self.loadingIndicator.startAnimating()
                } else {
                    self.tableView.alpha = 1
                    self.loadingIndicator.stopAnimating()
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
    
extension MatchInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.5, delay: 0.1 * Double(indexPath.row), options: [.curveEaseInOut], animations: {
            cell.alpha = 1
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            guard let playerDetailsVC = RouteManagerFactory.shared.routes[RouteConstants.playerDetailsViewControllerId] as? PlayerDetailsViewController else { return }
            
            guard let model = fixtureModel else { return }
            
            playerDetailsVC.id = model.manOfMatchId
            
            navigationController?.pushViewController(playerDetailsVC, animated: true)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MatchInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: AboutInfoTableViewCell.id, for: indexPath) as! AboutInfoTableViewCell
            guard let model = fixtureModel else { return cell }
            
            cell.setModelValues(model: model)
            
            cell.layer.cornerRadius = 20
            
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: GenInfoTableViewCell.id, for: indexPath) as! GenInfoTableViewCell
            guard let model = fixtureModel else { return cell }
            if model.status == Status.finished.rawValue {
                cell.setModelValues(image: "trophy (1)", text: "\(model.note)!")
            } else {
                cell.setModelValues(image: "trophy (1)", text: "Match winner isn't declared yet")
            }
            cell.layer.cornerRadius = 20
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: GenInfoTableViewCell.id, for: indexPath) as! GenInfoTableViewCell
            guard let model = fixtureModel else { return cell }
            if model.status == Status.finished.rawValue {
                cell.setModelValues(image: "coin-toss (1)", text: "\(model.tossWinner) was the toss winner & opt. to \(model.elected)")
            } else {
                cell.setModelValues(image: "coin-toss (1)", text: "Toss winner not available!")
            }
            cell.layer.cornerRadius = 20
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: AboutInfoTableViewCell.id, for: indexPath) as! AboutInfoTableViewCell
            guard let model = fixtureModel else { return cell }
            if model.status == Status.finished.rawValue {
                cell.setModelValuesForVMom(model: model)
            } else {
                cell.leagueImageView.sd_setImage(with: URL(string: model.manOfMatchImage), placeholderImage: UIImage(named: "cricket") , options: .progressiveLoad)
                cell.leagueName.text = "Man of the match is not available."
                cell.season.text = ""
                cell.round.text = ""
            }
            cell.layer.cornerRadius = 20
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: GenInfoTableViewCell.id, for: indexPath) as! GenInfoTableViewCell
            guard let model = fixtureModel else { return cell }
            if model.status == Status.finished.rawValue {
                cell.setModelValues(image: "umpire", text: "\(model.firstUmpire) & \(model.secondUmpire) were the umpires.")
            } else {
                cell.setModelValues(image: "umpire", text: "Umpires data isn't avaiable yet.")
            }
            cell.layer.cornerRadius = 20
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: GenInfoTableViewCell.id, for: indexPath) as! GenInfoTableViewCell
            guard let model = fixtureModel else { return cell }
            if model.status == Status.finished.rawValue {
                cell.setModelValues(image: "referee", text: "\(model.referee) was the referee.")
            } else {
                cell.setModelValues(image: "referee", text: "Referee name isn't available!")
            }
            cell.layer.cornerRadius = 20
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: AboutInfoTableViewCell.id, for: indexPath) as! AboutInfoTableViewCell
            guard let model = fixtureModel else { return cell }
            
            cell.setModelValuesForVenue(model: model)
            cell.layer.cornerRadius = 20
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fixtureModel == nil ? 0 : 7
    }
}
    
    
    
    
    
    
