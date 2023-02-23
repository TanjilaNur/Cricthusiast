//
//  PlayerDetailsViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/14/23.
//

import UIKit
import Combine

class PlayerSubVCIdConstants {
    static let infoVCid = "PlayerInfoViewController"
    static let careerVCid = "PlayerCareerViewController"
    static let teamVCid = "PlayerTeamsViewController"
    static let statVCid = "PlayerStatViewController"
    
}

class PlayerDetailsViewController: UIViewController {
    
    var id: Int!
    
    @IBOutlet weak var playerCFlag: UIImageView!
    
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var playerCountry: UILabel!
    
    @IBOutlet weak var playerImage: UIImageView!
    
    @IBOutlet weak var containerVCView: UIView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var contentView: UIView!
    
    let tabList = ["Info", "Teams", "Career","Stats"]
    var tag = 0
    
    let viewModel = PlayerDetailsViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    var info:PlayerPersonalInfoModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        
        playerImage.layer.cornerRadius = playerImage.frame.height / 2
        contentView.layer.masksToBounds = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: collectionView.bounds.width * 0.2, height: 40)
        
        layout.minimumInteritemSpacing = 10
    
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: TabCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: TabCollectionViewCell.id)
        initiateVcWith(tag: 0)
        viewModel.fetchInfo(id: id)
        setupBinders()
    }
    
    
    
    func setupBinders() {
        viewModel.$isLoading.sink {[weak self] isLoading in
            
            guard let self = self else { return }
            
            if !isLoading {
                DispatchQueue.main.async {
                  
                    self.playerCFlag.sd_setImage(with: URL(string: self.viewModel.info?.cfImgUrl ?? "N/A"), placeholderImage: UIImage(systemName: "photo"), options: .progressiveLoad)
                    self.playerImage.sd_setImage(with: URL(string: self.viewModel.info?.imgUrl ?? "N/A"), placeholderImage: UIImage(systemName: "photo"), options: .progressiveLoad)
                    self.playerName.text = self.viewModel.info?.name ?? "N/A"
                    self.playerCountry.text = self.viewModel.info?.country ?? "N/A"
                }
            }
        }.store(in: &cancellables)
    }
    
    func setSelectedVC(_ selectedVC: UIViewController) {
        addChild(selectedVC)
        selectedVC.view.frame = containerVCView.bounds
        containerVCView.addSubview(selectedVC.view)
        selectedVC.didMove(toParent: self)
    }
    
    func initiateVcWith(tag: Int){
        let storyboard = UIStoryboard(name: "Players", bundle: nil)
        
        let infoVC = storyboard.instantiateViewController(withIdentifier: PlayerSubVCIdConstants.infoVCid)
        
        let careerVC = storyboard.instantiateViewController(withIdentifier: PlayerSubVCIdConstants.careerVCid)
        
        let teamVC = storyboard.instantiateViewController(withIdentifier: PlayerSubVCIdConstants.teamVCid)
        
        let statVC = storyboard.instantiateViewController(withIdentifier: PlayerSubVCIdConstants.statVCid)
        
        let selectedVC: UIViewController
        
        switch tag {
        case 0:
            // INFO
            selectedVC = infoVC
        case 1:
            // career
            selectedVC = teamVC
        case 2:
            // career
            selectedVC = careerVC
        case 3:
            //stat
            selectedVC = statVC
            
        default:
            selectedVC = infoVC
        }
        setSelectedVC(selectedVC)
    }

}

//MARK: -UICollectionViewDataSource
extension PlayerDetailsViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCollectionViewCell.id, for: indexPath) as! TabCollectionViewCell
        
        let item = tabList[indexPath.row]
        
        if item == tabList[tag]{
            cell.selectionView.backgroundColor = UIColor(named: "primary")
//            cell.selectionView.layer.cornerRadius = cell.selectionView.frame.height / 2
            cell.selectionView.clipsToBounds = true
            cell.selectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.selectionView.layer.cornerRadius = 5
            cell.cellLabel.backgroundColor = UIColor(named: "gray6")
            cell.cellLabel.alpha = 1

        } else {
            cell.selectionView.backgroundColor = UIColor(named: "gray6")
            cell.cellLabel.backgroundColor = UIColor(named: "gray6")
            cell.cellLabel.alpha = 0.7
        }
        
        cell.cellLabel.text = tabList[indexPath.row]
        
        return cell
    }
}


//MARK: - UICollectionViewDelegate
extension PlayerDetailsViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tag = indexPath.row
        initiateVcWith(tag: indexPath.row)
        collectionView.reloadData()
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
//extension PlayerDetailsViewController: UICollectionViewDelegateFlowLayout
//{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: collectionView.bounds.width * 0.5, height: 40)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//}


