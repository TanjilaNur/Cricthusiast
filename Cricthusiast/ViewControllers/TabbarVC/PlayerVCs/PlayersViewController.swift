//
//  PlayersViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/13/23.
//

import UIKit
import Combine

class PlayersViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var playersTableView: UITableView!
    
    var playerModels: [PlayerCellModel] = []
    let viewModel = PlayersViewModel()
    
    var cancellables : Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBarImage()
        
        playersTableView.layer.cornerRadius = 20
        playersTableView.dataSource = self
        playersTableView.delegate = self
        playersTableView.register(UINib(nibName: PlayersTableViewCell.id, bundle: nil), forCellReuseIdentifier: PlayersTableViewCell.id)
        
        viewModel.fetchPlayersData()
        setupBinders()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.backBarButtonItem?.title = ""
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }
    
    func setupBinders(){
        viewModel.$playerList.sink {[weak self] players in
            guard let self = self else { return }
            self.playerModels = players
            
            DispatchQueue.main.async {
                self.playersTableView.reloadData()
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
                    self.viewModel.fetchPlayersData()
                }

                alertController.addAction(okayAction)
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true)
            }
        }.store(in: &cancellables)
    }
    
    @IBAction func searchQueryChanged(_ sender: UITextField) {
        viewModel.searchPlayer(query: sender.text ?? "")
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
}

// MARK: - UITableViewDelegate
extension PlayersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let playerDetailsVC = RouteManagerFactory.shared.routes[RouteConstants.playerDetailsViewControllerId] as? PlayerDetailsViewController else { return }
        
        playerDetailsVC.id = playerModels[indexPath.row].id
        playersTableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(playerDetailsVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension PlayersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playerModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playersTableView.dequeueReusableCell(withIdentifier: PlayersTableViewCell.id, for: indexPath) as!  PlayersTableViewCell
        
        let model = playerModels[indexPath.row]
        cell.setValuesForPlayers(model: model)

        return cell
    }

}


