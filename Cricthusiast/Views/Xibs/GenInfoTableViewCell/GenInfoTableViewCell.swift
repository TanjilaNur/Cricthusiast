//
//  GenInfoTableViewCell.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/15/23.
//

import UIKit
import SDWebImage

class GenInfoTableViewCell: UITableViewCell {
    
    static let id = "GenInfoTableViewCell"
    
    @IBOutlet weak var iamgeView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setModelValues(image: String, text: String){
        iamgeView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: image) , options: .progressiveLoad)
        label.text = text
    }
    
}
