//
//  MoreViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/23/23.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        topView.clipsToBounds = true
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        topView.layer.cornerRadius = 20
        
        tableView.register(UINib(nibName: MoreTableViewCell.id, bundle: nil), forCellReuseIdentifier: MoreTableViewCell.id)
    }
}
extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.5, delay: 0.1 * Double(indexPath.row), options: [.curveEaseInOut], animations: {
            cell.alpha = 1
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let rankingVC = RouteManagerFactory.shared.routes[RouteConstants.rankingViewControllerId] as? RankingViewController else { return }
            
            navigationController?.pushViewController(rankingVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
            
        } else if indexPath.row == 1 {
            guard let teamsVC = RouteManagerFactory.shared.routes[RouteConstants.teamsViewControllerId] as? TeamsViewController else { return }
            
            navigationController?.pushViewController(teamsVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        } else if indexPath.row == 2 {
            guard let dateWiseFixtureVC = RouteManagerFactory.shared.routes[RouteConstants.matchDateViewControllerId] as? MatchDateViewController else { return }
            
            navigationController?.pushViewController(dateWiseFixtureVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - TableView Delegate

extension MoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func setUpCellStyle(_ cell: MoreTableViewCell) {
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        cell.layer.shadowColor = UIColor.systemGray3.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreTableViewCell.id, for: indexPath) as! MoreTableViewCell
        
        switch indexPath.row {
        case 0 :
            cell.titleLabel.text = "Teams"
            cell.iconView.image = UIImage(systemName: "person.3.fill")
            cell.layer.cornerRadius = 20
            return cell
            
        case 1 :
            cell.titleLabel.text = "Global Rangkings"
            cell.iconView.image = UIImage(systemName: "chart.bar.xaxis")
            cell.layer.cornerRadius = 20

            return cell
        case 2 :
            cell.titleLabel.text = "Date Wise fixtures"
            cell.iconView.image = UIImage(systemName: "calendar")
            cell.layer.cornerRadius = 20

            return cell

        default:
            cell.titleLabel.text = "Teams"
            cell.iconView.image = UIImage(systemName: "person.3.fill")
            cell.layer.cornerRadius = 20

            return cell
        }
    }
}
