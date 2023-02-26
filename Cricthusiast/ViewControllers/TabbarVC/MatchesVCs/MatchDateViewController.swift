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
    
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = MatchViewModel()
    
    var fixtureModels : [MatchCellModel] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Date Wise Fixtures"

        // Do any additional setup after loading the view.
        
        endDatePicker.date = startDatePicker.date.addingTimeInterval(20 * 24 * 60 * 60.0)
        viewModel.fetchDataByTime(date: startDatePicker.date, finishingDate: endDatePicker.date)
        
        collectionView.dataSource = self

        collectionView.layer.cornerRadius = 30
        collectionView.layer.masksToBounds = true
        
        
        topView.clipsToBounds = true
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        topView.layer.cornerRadius = 20
    
        let layout = UICollectionViewFlowLayout()
        layout.itemSize  = CGSize(width: collectionView.bounds.width * 0.95, height: 175)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: "FeaturedMatchesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedMatchesCollectionViewCell")
        setupBinders()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        navigationController?.navigationBar.backItem?.title = "Back"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        viewModel.fetchDataByTime(date: startDatePicker.date,finishingDate: endDatePicker.date)
        collectionView.reloadData()
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
        
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.systemGray3.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.setValues(model: model)
        return cell
    }

}
