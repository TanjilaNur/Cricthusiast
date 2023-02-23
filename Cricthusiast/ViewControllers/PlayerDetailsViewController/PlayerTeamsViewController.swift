//
//  PlayerTeamsViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/23/23.
//

import UIKit
import Combine

class PlayerTeamsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cancellables: Set<AnyCancellable> = []
    let viewModel = PlayerDetailsViewModel()
    
    var allTeams:[Team] = []
    var currentTeams:[Team] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.sectionHeaderTopPadding = 0
        
        let parentVC = self.parent as! PlayerDetailsViewController
        
        tableView.register(UINib(nibName: GenInfoTableViewCell.id, bundle: nil), forCellReuseIdentifier: GenInfoTableViewCell.id)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "headerView")

        
        viewModel.fetchTeams(id: parentVC.id ?? -1)
        setupBinder()
    }
    
    func setupBinder(){
        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            if (!isLoading) {
                self.allTeams = self.viewModel.allTeams
                self.currentTeams = self.viewModel.currentTeams
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }.store(in: &cancellables)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.lightGray
        
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.width - 20, height: headerView.frame.height))
        if section == 0 {
            titleLabel.text = "Current Teams"
        } else {
            titleLabel.text = "All Teams"
        }
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        titleLabel.textColor = UIColor(named: "primary")
        
        headerView.addSubview(titleLabel)
        
        return headerView
    }
}

extension PlayerTeamsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // Return a height of 10 points for the footer view to act as the gap
        return 20
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.5, delay: 0.1 * Double(indexPath.row), options: [.curveEaseInOut], animations: {
            cell.alpha = 1
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}

extension PlayerTeamsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return currentTeams.count
        } else {
            return allTeams.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Current Teams"
        } else {
            return "All Teams"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: GenInfoTableViewCell.id, for: indexPath) as! GenInfoTableViewCell
            let model = allTeams[indexPath.row]
            cell.setModelValues(image: model.imagePath ?? "", text: model.name ?? "N/A")
            cell.label.textAlignment = .left
            cell.layer.cornerRadius = 10
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: GenInfoTableViewCell.id, for: indexPath) as! GenInfoTableViewCell
            let model = allTeams[indexPath.row]
            cell.setModelValues(image: model.imagePath ?? "", text: model.name ?? "N/A")
            cell.label.textAlignment = .left
            cell.layer.cornerRadius = 10
            return cell
        }
    }
}


