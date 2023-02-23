//
//  PlayerInfoViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/20/23.
//

import UIKit
import Combine


class PlayerInfoViewController: UIViewController {
    
//    @IBOutlet weak var infoCollectionView: UICollectionView!
    
    var cancellables: Set<AnyCancellable> = []
    
    let viewModel = PlayerDetailsViewModel()
    
    
    @IBOutlet var views: [UIView]!
    
    @IBOutlet var titles: [UILabel]!
    
    @IBOutlet weak var headerView: UIView!
    
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
        viewModel.fetchInfo(id: parentVC.id ?? -1)
        setupBinder()
    }
    
    func setupBinder(){
        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            if (!isLoading) {
                let labelText = [
                    self.viewModel.info?.dob,
                    self.viewModel.info?.birthPlace,
                    self.viewModel.info?.nickName,
                    self.viewModel.info?.role,
                    self.viewModel.info?.battingStyle.capitalized,
                    self.viewModel.info?.bowlingStyle.capitalized
                ]
                
                for i in 0...self.infoLabels.count - 1 {
                    self.infoLabels[i].text  = labelText[i]
                }
            }
        }.store(in: &cancellables)
    }
}




