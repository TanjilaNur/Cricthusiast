//
//  NewsTableViewCell.swift
//  MidTerm-NewsApp
//
//  Created by BJIT on 16/1/23.
//

import UIKit
import SDWebImage

import UIKit

class NewsTableViewCellModel {
    let source: String?
    let title : String?
    let newsDescription: String?
    let content: String?
    let author: String?
    let date: String?
    let imgURL: String?
    let url: String?
    var imgData: Data? = nil
    var isBookmarked: Bool
    
    init (source: String, title : String, description: String, content: String, author: String,imgURL: String, url: String,date: String, isBookmarked: Bool){

        self.source = source
        self.title = title
        self.newsDescription = description
        self.content = content
        self.author = author
        self.imgURL = imgURL
        self.url = url
        self.date = date
        self.isBookmarked = isBookmarked
    }
}

class NewsTableViewCell: UITableViewCell {
    
    static let id = "NewsTableViewCell"

    @IBOutlet weak var rootView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    
    @IBOutlet weak var publishedTimeLabel: UILabel!
    
//    @IBOutlet weak var shareBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @IBAction func shareBtnTapped(_ sender: UIButton) {
//    }
    
    
}

