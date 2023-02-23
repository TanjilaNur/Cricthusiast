//
//  PlayerCareerViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 21/2/23.
//

import UIKit
import Combine

class PlayerCareerViewController: UIViewController {
    
    @IBOutlet weak var careerCollectionView: UICollectionView!
    
    @IBOutlet weak var scSegmentControl: UISegmentedControl!
    
    let viewModel = PlayerDetailsViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        careerCollectionView.delegate = self
        careerCollectionView.dataSource = self
        careerCollectionView.layer.cornerRadius = 20
        let layout = UICollectionViewFlowLayout()
        layout.itemSize  = CGSize(width: careerCollectionView.bounds.width * 0.95, height: 200)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        careerCollectionView.collectionViewLayout = layout
        
        careerCollectionView.register(UINib(nibName: BattingCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: BattingCollectionViewCell.id)
        
        // Do any additional setup after loading the view.
        let parent = parent as! PlayerDetailsViewController
        
        viewModel.fetchCareerInfo(id: parent.id)
        setupBinders()
    }
    
    func setupBinders() {
        viewModel.$isLoading.sink {[weak self] isLoading in
            guard let self = self else { return }
            
            if (!isLoading) {
                DispatchQueue.main.async {
                    self.careerCollectionView.reloadData()
                }
            }
        }.store(in: &cancellables)
    }
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        careerCollectionView.reloadData()
        
    }
    
    
}

extension PlayerCareerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if scSegmentControl.selectedSegmentIndex == 0 {
            return viewModel.battingData.count
        } else {
            return viewModel.bowlingData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BattingCollectionViewCell.id, for: indexPath) as! BattingCollectionViewCell
        
        if scSegmentControl.selectedSegmentIndex == 0 {
            let model = viewModel.battingData[indexPath.row]
            cell.setBattingData(data: model)
        } else {
            let model = viewModel.bowlingData[indexPath.row]
            cell.setBowlingData(data: model)
        }
        
        return cell
    }
}

extension PlayerCareerViewController: UICollectionViewDelegate {

}
