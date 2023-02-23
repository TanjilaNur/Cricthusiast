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
//        setUpBinder()
        setSearchBarImage()
        
        playersTableView.layer.cornerRadius = 20
        playersTableView.dataSource = self
        playersTableView.delegate = self
        playersTableView.register(UINib(nibName: PlayersTableViewCell.id, bundle: nil), forCellReuseIdentifier: PlayersTableViewCell.id)
        
        viewModel.fetchPlayersData()
        setupBinders()

    }
    
    func setupBinders(){
//        viewModel.$fixtureModels.sink { [weak self] fixtureModels in
//
//            guard let self = self else { return }
//
//            self.fixtureModels = fixtureModels
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }.store(in: &cancellables)
        viewModel.$playerList.sink {[weak self] players in
            guard let self = self else { return }
            self.playerModels = players
            
            DispatchQueue.main.async {
                self.playersTableView.reloadData()
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

////MARK: UICollectionViewDelegateFlowLayout
//extension PlayersViewController: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }
//}

// MARK: - UITableViewDelegate
extension PlayersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let playerDetailsVC = RouteManager.shared.routes[RouteConstants.playerDetailsViewControllerId] as? PlayerDetailsViewController else { return }
        
        playerDetailsVC.id = playerModels[indexPath.row].id
        playersTableView.deselectRow(at: indexPath, animated: true)
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


