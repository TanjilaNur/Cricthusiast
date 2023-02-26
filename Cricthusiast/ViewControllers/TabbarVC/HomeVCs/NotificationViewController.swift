//
//  NotificationViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/25/23.
//

import UIKit
import Combine

class NotificationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = HomeViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    var notificationFixtures: [PlayerCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notifications"

        tableView.layer.cornerRadius = 20
        tableView.dataSource = self
        tableView.register(UINib(nibName: PlayersTableViewCell.id, bundle: nil), forCellReuseIdentifier: PlayersTableViewCell.id)
        viewModel.getAllAddedNotification()
        setupBinder()
    }
    
    func setupBinder() {
        viewModel.$isLoading.sink {[weak self] isLoading in
            guard let self = self else { return }

            self.notificationFixtures = self.viewModel.notificationModel
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }.store(in: &cancellables)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationController?.navigationBar.backItem?.title = "Back"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }

}

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notificationFixtures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayersTableViewCell.id, for: indexPath) as! PlayersTableViewCell
        
        let model = notificationFixtures[indexPath.row]
        
        cell.setValuesForPlayers(model: model)
        return cell
    }
}
