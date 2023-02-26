//
//  MatchDateViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 26/2/23.
//

import UIKit
import Combine

class MatchDateViewController: UIViewController {

    
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = MatchViewModel()
    
    var fixtureModels : [MatchCellModel] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.fetchDataByTime(date: startDatePicker.date)
        collectionView.dataSource = self

        collectionView.layer.cornerRadius = 30
        collectionView.layer.masksToBounds = true
    
        let layout = UICollectionViewFlowLayout()
        layout.itemSize  = CGSize(width: collectionView.bounds.width * 0.95, height: 175)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: "FeaturedMatchesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedMatchesCollectionViewCell")
        setupBinders()
    }
    
    func setupBinders() {
        viewModel.$isLoading.sink {[weak self] isLoading in
            
            guard let self = self else {
                return
            }
            
            if (!isLoading) {
                self.fixtureModels = self.viewModel.fixtureModels
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }.store(in: &cancellables)
    }
    
}

extension MatchDateViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fixtureModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedMatchesCollectionViewCell", for: indexPath) as! FeaturedMatchesCollectionViewCell
        let model = fixtureModels[indexPath.row]
        cell.setValues(model: model)
        return cell
    }
    
    
}
