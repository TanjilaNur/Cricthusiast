//
//  PlayerStatViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/23/23.
//

import UIKit
import Combine


class PlayerStatViewController: UIViewController {
      
    var cancellables: Set<AnyCancellable> = []
    
    let viewModel = PlayerDetailsViewModel()
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet var views: [UIView]!
    
    @IBOutlet var titles: [UILabel]!

    @IBOutlet var infoLabels: [UILabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parentVC = self.parent as! PlayerDetailsViewController
        
        headerView.layer.cornerRadius = 10
        headerView.layer.masksToBounds = true
        
        for view in views {
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
        }
        for title in titles {
            title.layer.cornerRadius = 10
            title.layer.masksToBounds = true
        }
        viewModel.fetchStats(id: parentVC.id ?? -1)
        setupBinder()
    }
    
    func setupBinder(){
        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            if (!isLoading) {
                let labelText = [
                    self.viewModel.stats?.runs,
                    self.viewModel.stats?.cent,
                    self.viewModel.stats?.sixs,
                    self.viewModel.stats?.fours,
                    self.viewModel.stats?.tests,
                    self.viewModel.stats?.t20s,
                    self.viewModel.stats?.odis,
                    self.viewModel.stats?.matches,
                    
                ]
                
                for i in 0...7 {
                    self.infoLabels[i].text  = labelText[i]
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
                    let parentVC = self.parent as! MatchDetailsViewController
                    
                    self.viewModel.fetchInfo(id: parentVC.id ?? -1)
                }

                alertController.addAction(okayAction)
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true)
            }
        }.store(in: &cancellables)
    }
}





