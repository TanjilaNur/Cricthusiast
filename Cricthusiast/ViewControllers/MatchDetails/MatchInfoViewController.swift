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
        
        let parentVC = self.parent as? MatchDetailsViewController
        
        let id = (parent as! MatchDetailsViewController).id
        viewModel.getMatchInfo(id: id!)
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
    //                self.loadingIndicator.alpha = 0
                    self.loadingIndicator.stopAnimating()
                }
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
            guard let playerDetailsVC = RouteManager.shared.routes[RouteConstants.playerDetailsViewControllerId] as? PlayerDetailsViewController else { return }
            
            guard let model = fixtureModel else { return }
            
            playerDetailsVC.id = model.manOfMatchId
            
            navigationController?.pushViewController(playerDetailsVC, animated: true)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension MatchInfoViewController: UITableViewDataSource {
    
    //    fileprivate func setUpCellStyle(_ cell: AboutInfoTableViewCell) {
    //        cell.contentView.layer.cornerRadius = 20
    //        cell.contentView.layer.borderWidth = 1.0
    //        cell.contentView.layer.borderColor = UIColor.clear.cgColor
    //        cell.contentView.layer.masksToBounds = true
    //
    //        cell.layer.shadowColor = UIColor.systemGray3.cgColor
    //        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
    //        cell.layer.shadowRadius = 2.0
    //        cell.layer.shadowOpacity = 1.0
    //        cell.layer.masksToBounds = false
    //        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    //    }
    
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
                cell.setModelValues(image: "trophy (1)", text: "Match has not started yet!!")
            }
            cell.layer.cornerRadius = 20
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: GenInfoTableViewCell.id, for: indexPath) as! GenInfoTableViewCell
            guard let model = fixtureModel else { return cell }
            if model.status == Status.finished.rawValue {
                cell.setModelValues(image: "coin-toss (1)", text: "\(model.tossWinner) was the toss winner & opt. to \(model.elected)")
            } else {
                cell.setModelValues(image: "coin-toss (1)", text: "Toss isn't done yet!")
            }
            cell.layer.cornerRadius = 20
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: GenInfoTableViewCell.id, for: indexPath) as! GenInfoTableViewCell
            guard let model = fixtureModel else { return cell }
            if model.status == Status.finished.rawValue {
                cell.setModelValues(image: model.manOfMatchImage, text: "MoM: \(model.manOfMatch) \n Position: \(model.manOfmatchPosition)")
            } else {
                cell.setModelValues(image: "cricket", text: "MoM is not still declared!")
            }
            cell.layer.cornerRadius = 20
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: GenInfoTableViewCell.id, for: indexPath) as! GenInfoTableViewCell
            guard let model = fixtureModel else { return cell }
            if model.status == Status.finished.rawValue {
                cell.setModelValues(image: "umpire", text: "\(model.firstUmpire)\n & \n\(model.secondUmpire)")
            } else {
                cell.setModelValues(image: "umpire", text: "Umpires are not announced yet!")
            }
            cell.layer.cornerRadius = 20
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: GenInfoTableViewCell.id, for: indexPath) as! GenInfoTableViewCell
            guard let model = fixtureModel else { return cell }
            if model.status == Status.finished.rawValue {
                cell.setModelValues(image: "referee", text: model.referee)
            } else {
                cell.setModelValues(image: "referee", text: "Referee isn't declared yet!")
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
    
    
    
    
    
    
