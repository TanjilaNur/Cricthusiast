//
//  GlobalTeamRankingViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 22/2/23.
//

import UIKit
import Combine

class RankingViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    
    let viewModel = GlobalTeamRankingViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        
        topView.clipsToBounds = true
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        topView.layer.cornerRadius = 20
        
        segmentController.defaultConfiguration(font: UIFont.systemFont(ofSize: 14), color: UIColor(named: "primary")!)
        segmentController.selectedConfiguration(font: UIFont.systemFont(ofSize: 16), color: .white)
        segmentController.layer.borderColor = UIColor(named: "primary")?.cgColor
        segmentController.layer.borderWidth = 1.0
        segmentController.layer.masksToBounds = true

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 70
        
        tableView.register(UINib(nibName: RankTableViewCell.id, bundle: nil), forCellReuseIdentifier: RankTableViewCell.id)
        
        setLeagueType(idx: segmentController.selectedSegmentIndex)
        setupBinders()
    }
    @IBAction func segmentBtnTapped(_ sender: UISegmentedControl) {
        setLeagueType(idx: segmentController.selectedSegmentIndex)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }
    
    func setLeagueType(idx: Int){
        switch idx{
        case 0:
            viewModel.fetchGlobalRanking(type: "TEST")
        case 1:
            viewModel.fetchGlobalRanking(type: "T20")
        default:
            viewModel.fetchGlobalRanking(type: "ODI")
        }
        tableView.reloadData()
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
        
        viewModel.$error.sink {[weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            DispatchQueue.main.async {
                print(error)
                let alertController = UIAlertController(title: "Something went wrong!", message: "Please check your interenet connection or try again later.", preferredStyle: .alert)

                let okayAction = UIAlertAction(title: "OK!", style: .default)

                let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { [weak self]_ in
                    guard let self = self else { return }
                    
                    self.setLeagueType(idx: self.segmentController.selectedSegmentIndex)
                }

                alertController.addAction(okayAction)
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true)
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

extension RankingViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}
