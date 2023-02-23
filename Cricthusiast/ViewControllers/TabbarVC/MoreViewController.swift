//
//  MoreViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/23/23.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
//        tableView.dataSource = self

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
            guard let playerDetailsVC = RouteManager.shared.routes[RouteConstants.playerDetailsViewControllerId] as? PlayerDetailsViewController else { return }
            
            navigationController?.pushViewController(playerDetailsVC, animated: true)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

//extension MoreViewController: UITableViewDataSource {
    
//        fileprivate func setUpCellStyle(_ cell: MoreTableViewCell) {
//            cell.contentView.layer.cornerRadius = 20
//            cell.contentView.layer.borderWidth = 1.0
//            cell.contentView.layer.borderColor = UIColor.clear.cgColor
//            cell.contentView.layer.masksToBounds = true
//
//            cell.layer.shadowColor = UIColor.systemGray3.cgColor
//            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//            cell.layer.shadowRadius = 2.0
//            cell.layer.shadowOpacity = 1.0
//            cell.layer.masksToBounds = false
//            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
//        }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.row {
//        case 0 :
//            let cell = tableView.dequeueReusableCell(withIdentifier: MoreTableViewCell.id, for: indexPath) as! MoreTableViewCell
//
//            cell.setModelValues(imgName: )
//
//            cell.layer.cornerRadius = 20
//
//            return cell
//
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: MoreTableViewCell.id, for: indexPath) as! MoreTableViewCell
//
//            cell.setModelValues(imgName: )
//
//            cell.layer.cornerRadius = 20
//
//            return cell
//        }
//    }
//}
