//
//  RecentMatchViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 3/2/23.
//

import UIKit
import Combine

class MatchViewController: UIViewController {
    
    var selectedTag = 1
    
    @IBOutlet var matchTypesButtons: [UIButton]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fixtureModels : [MatchCellModel] = []
    
    let viewModel = MatchViewModel()
    
    var cancellables : Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
     
        setUpBinder()
        
        setButtonState()
        viewModel.fetchData(tag: selectedTag)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 20
        let layout = UICollectionViewFlowLayout()
        layout.itemSize  = CGSize(width: collectionView.bounds.width * 0.95, height: 175)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: "FeaturedMatchesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedMatchesCollectionViewCell")
        
    }
    
    func setUpBinder(){
        viewModel.$fixtureModels.sink { [weak self] fixtureModels in
            
            guard let self = self else { return }
            
            self.fixtureModels = fixtureModels
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.store(in: &cancellables)
    }
    
    fileprivate func setButtonState() {
        for button in matchTypesButtons {
            if (button.tag == selectedTag) {
                UIView.animate(withDuration: 0.2, delay: 0) {[weak self] in
                    button.alpha = 1
                    self?.view.layoutIfNeeded()
                }
            } else {
                UIView.animate(withDuration: 0.2, delay: 0) {[weak self] in
                    button.alpha = 0.5
                    self?.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @IBAction func statusButtonTapped(_ sender: UIButton) {
        selectedTag = sender.tag
        setButtonState()
        viewModel.fetchData(tag: selectedTag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        collectionView.reloadData()
    }
}

extension MatchViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? FeaturedMatchesCollectionViewCell  else {
            return
        }
        cell.stopCountingDown()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fixtureModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedMatchesCollectionViewCell", for: indexPath) as! FeaturedMatchesCollectionViewCell
        
        let model = fixtureModels[indexPath.row]
        
        cell.setValues(model: model, tag: selectedTag)
        
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
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MatchViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailsVC = RouteManager.shared.routes[RouteConstants.matchDetailsViewControllerId] as? MatchDetailsViewController else { return }
        detailsVC.id = fixtureModels[indexPath.row].id
        navigationController?.pushViewController(detailsVC, animated: true)
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.5, delay: 0.1 * Double(indexPath.row ) / 4.0, options: [.curveEaseOut], animations: {
            cell.alpha = 1
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MatchViewController: UICollectionViewDelegateFlowLayout
{
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//            return CGSize(width: 250, height: 180)
//        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}




