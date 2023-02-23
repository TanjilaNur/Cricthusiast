//
//  MatchSquadsViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/14/23.
//

import UIKit
import Combine


class MatchSquadsViewController: UIViewController {
    @IBOutlet weak var snayImage: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var localTeamName: UILabel!
    
    @IBOutlet weak var visitorTeamName: UILabel!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var squadModels : [SquadCollectionViewCellModel] = []
    
    var cancellables: Set<AnyCancellable> = []
    let viewModel = MatchDetailsViewModel()
    
    var parentVC: MatchDetailsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
    
        let nib = UINib(nibName: SquadCollectionViewCell.id, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: SquadCollectionViewCell.id)

        collectionView.collectionViewLayout = createLayout()
        
        parentVC = self.parent as? MatchDetailsViewController
//        viewModel.fetchMatchScore(id: parentVC.selectedFixtureId ?? -1)
        setupBinders()
        viewModel.fetchSquadInfo(id: parentVC.id)
    }
    
    func setupBinders(){
        viewModel.$finalSquadModel.sink {[weak self] squadModels in
            guard let self = self else {
                return
            }
            self.squadModels = squadModels
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.$teamNames.sink {[weak self] teamNames in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.localTeamName.text = teamNames.first
                self.visitorTeamName.text = teamNames.last
                self.collectionView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.$isRecent.sink {[weak self] isRecent in
            guard let self = self, let isRecent = isRecent else {
                return
            }
            
            if (!isRecent) {
                self.collectionView.layer.opacity = 0
            } else {
                self.collectionView.layer.opacity = 1
            }

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.collectionView.alpha = 0
                    self.snayImage.alpha = 0
                    self.loadingIndicator.startAnimating()
                } else {
                    self.loadingIndicator.stopAnimating()
                    self.snayImage.alpha = 1
                    if self.squadModels.isEmpty {
                        self.collectionView.alpha = 0
                    } else {
                        self.collectionView.alpha = 1
                    }
                }
            }
        }.store(in: &cancellables)
    }
    
    func createLayout() -> UICollectionViewLayout {
        var customGroup: NSCollectionLayoutGroup?
        var item: NSCollectionLayoutItem?
        
        item = createItem(1/2,1)
        customGroup = createGroup(1, 1/7, item!, item!)

        let section = NSCollectionLayoutSection(group: customGroup!)
        
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return compositionalLayout
    }
    
    func createItem(_ width: Double, _ height: Double)-> NSCollectionLayoutItem {
        let insets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(width), heightDimension: .fractionalHeight(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = insets
        
        return item
    }
    
    func createGroup(_ width: Double, _ height: Double, _ item1: NSCollectionLayoutItem, _ item2: NSCollectionLayoutItem)-> NSCollectionLayoutGroup {
        
        let cusGroup : NSCollectionLayoutGroup
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(width), heightDimension: .fractionalHeight(height))
        cusGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item1,item2])
        return cusGroup
    }
}


// MARK: - UICollectionViewDataSource
extension MatchSquadsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return squadModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SquadCollectionViewCell.id, for: indexPath) as! SquadCollectionViewCell
        
        cell.setSquadCVCellValues(model: squadModels[indexPath.row], index: indexPath.row)
        return cell
    }
}


//MARK: UICollectionViewDelegateFlowLayout
extension MatchSquadsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

// MARK: - UICollectionViewDelegate
extension MatchSquadsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let playerDetailsVC = RouteManager.shared.routes[RouteConstants.playerDetailsViewControllerId] as? PlayerDetailsViewController else { return }
        playerDetailsVC.id = squadModels[indexPath.row].playerId
        
        navigationController?.pushViewController(playerDetailsVC, animated: true)
        
        collectionView.deselectItem(at: indexPath, animated: true)

    }
}


