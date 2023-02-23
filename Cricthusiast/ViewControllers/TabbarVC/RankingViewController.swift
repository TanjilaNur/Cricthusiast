//
//  GlobalTeamRankingViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 22/2/23.
//

import UIKit
import Combine

class RankingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    let viewModel = GlobalTeamRankingViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentController.defaultConfiguration(font: UIFont.systemFont(ofSize: 14), color: UIColor(named: "primary")!)
        segmentController.selectedConfiguration(font: UIFont.systemFont(ofSize: 16), color: .white)

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.rowHeight = 70
        
        tableView.register(UINib(nibName: RankTableViewCell.id, bundle: nil), forCellReuseIdentifier: RankTableViewCell.id)
        
        viewModel.fetchGlobalRanking()
        setupBinders()
        
    }
    
    func setupBinders() {
        viewModel.$isLoading.sink {[weak self] isLoading in
            guard let self = self else { return }
            if (!isLoading) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }.store(in: &cancellables)
    }


}

extension RankingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rankingTeamModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RankTableViewCell.id, for: indexPath) as! RankTableViewCell
        let model = viewModel.rankingTeamModels[indexPath.row]
        
        cell.setValues(model: model)
        return cell
    }
}
