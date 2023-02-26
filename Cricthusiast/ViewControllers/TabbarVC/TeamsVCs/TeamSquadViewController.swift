//
//  TeamSquadViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/25/23.
//

import UIKit
import Combine

class TeamSquadViewController: UIViewController {
    
    var id: Int!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var squadPlayers: [PlayerCellModel] = []
    
    let viewModel = TeamsViewModel()
    var cancellables : Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBarImage()
        
        topView.clipsToBounds = true
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        topView.layer.cornerRadius = 20
        
        tableView.layer.cornerRadius = 20
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: PlayersTableViewCell.id, bundle: nil), forCellReuseIdentifier: PlayersTableViewCell.id)
        
        viewModel.fetchTeamSquad(by: id)
        setupBinders()
    }
    
//    @IBAction func searchQueryChanges(_ sender: UITextField) {
//        viewModel.searchTeamSquadMember(query: sender.text ?? "")
//    }
    
    
    @IBAction func searchQueryChanges(_ sender: UITextField) {
        viewModel.searchTeamSquadMember(query: sender.text ?? "")
    }
    
    func setSearchBarImage(){
        let searchIcon  = UIImageView()
        searchIcon.tintColor = UIColor(named: "primary")
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        let uiView = UIView()
        uiView.addSubview(searchIcon)
        uiView.frame = CGRect(x: 10, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width+15, height: UIImage(systemName: "magnifyingglass")!.size.height)
        
        searchIcon.frame = CGRect(x: 10, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width, height: UIImage(systemName: "magnifyingglass")!.size.height)
        
        searchTextField.leftView = uiView
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.leftViewMode = .always
    }
    
    func setupBinders(){
        viewModel.$isLoading.sink {[weak self] isLoading in
            guard let self = self else { return }
            if !isLoading {
                self.tableView.alpha = 1
                self.activityIndicator.stopAnimating()
                self.squadPlayers = self.viewModel.queryteamSquadModel
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                self.tableView.alpha = 0
                self.activityIndicator.startAnimating()
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
                    let parentVC = self.parent as! MatchDetailsViewController
                    
                    self.viewModel.fetchTeamSquad(by: self.id)
                }

                alertController.addAction(okayAction)
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true)
            }
        }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.backBarButtonItem?.title = ""
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }
}

// MARK: - UITableViewDelegate
extension TeamSquadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let playerDetailsVC = RouteManagerFactory.shared.routes[RouteConstants.playerDetailsViewControllerId] as? PlayerDetailsViewController else { return }
        
        playerDetailsVC.id = squadPlayers[indexPath.row].id
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(playerDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
    }
}

// MARK: - UITableViewDataSource
extension TeamSquadViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        squadPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayersTableViewCell.id, for: indexPath) as!  PlayersTableViewCell
        
        let model = squadPlayers[indexPath.row]
        cell.setValuesForPlayers(model: model)

        return cell
    }

}
