//
//  NewsTableViewCell.swift
//  MidTerm-NewsApp
//
//  Created by BJIT on 16/1/23.
//

import UIKit
import SDWebImage

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let id = "NewsTableViewCell"
    
    @IBOutlet weak var rootView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    
    @IBOutlet weak var publishedTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

