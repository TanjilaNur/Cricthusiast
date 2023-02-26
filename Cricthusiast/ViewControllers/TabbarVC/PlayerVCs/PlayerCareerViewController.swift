//
//  PlayerCareerViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 21/2/23.
//

import UIKit
import Combine

class PlayerCareerViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var careerCollectionView: UICollectionView!
    
    @IBOutlet weak var scSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    let viewModel = PlayerDetailsViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            if isLoading {
                self.careerCollectionView.alpha = 0
                self.noDataLabel.alpha = 0
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
                self.noDataLabel.alpha = 1
                self.careerCollectionView.alpha = 1
                self.careerCollectionView.reloadData()
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

