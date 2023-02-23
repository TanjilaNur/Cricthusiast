//
//  TabCollectionViewCell.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/22/23.
//

import UIKit

class TabCollectionViewCell: UICollectionViewCell {
    
    static let id = "TabCollectionViewCell"
    
    @IBOutlet weak var cellBgView: UIView!
    
    @IBOutlet weak var cellLabel: UILabel!
    
    @IBOutlet weak var selectionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        cellLabel.backgroundColor = .systemBackground
    }

}
