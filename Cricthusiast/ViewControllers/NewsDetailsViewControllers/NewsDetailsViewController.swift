//
//  NewsDetailsViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/14/23.
//

//import UIKit
//
//class NewsDetailsViewController: UIViewController {
//    
//    var delegate : UpdateBookmarks?
//    
//    var viewModel: TableViewCellViewModel?
//    
//    var selectedCategory: CategoryList?
//    
//    var indexPath: IndexPath?
//    
//    var bookmarkBtnOpacity = 1
//    
//    @IBOutlet weak var bookmarkbutton: UIBarButtonItem!
//    
//    @IBOutlet weak var newsImageView: UIImageView!
//    
//    @IBOutlet weak var dateLabel: UILabel!
//    
//    @IBOutlet weak var contentLabel: UILabel!
//    
//    @IBOutlet weak var newsTitleLabel: UILabel!
//    
//    @IBOutlet weak var newDescription: UILabel!
//    
//    @IBOutlet weak var detailsSubView: UILabel!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setUpDetailsView()
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToWebView" {
//            if let vc = segue.destination as? WebViewController {
//                vc.url = viewModel?.url
//            }
//        }
//    }
//
//    
//    //MARK: -Button Action
//    @IBAction func continueReadingBtnTapped(_ sender: UIButton) {
//        
//        isInternetAvailable {[weak self] isAvailable in
//            guard let self = self else { return }
//            if (isAvailable) {
//                DispatchQueue.main.async {
//                    self.performSegue(withIdentifier: "goToWebView", sender: nil)
//                }
//                
//            } else {
//                DispatchQueue.main.async {
//
//                    let alertController = UIAlertController(title: "Error occured!", message: "Please check connectivity or try again later!", preferredStyle: .alert)
//                    
//                    let okayAction = UIAlertAction(title: "OK!", style: .default)
//                    
//                    let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { [weak self]_ in
//                        guard let self = self else { return }
//                        self.continueReadingBtnTapped(sender)
//                    }
//                    
//                    alertController.addAction(okayAction)
//                    alertController.addAction(tryAgainAction)
//                    self.present(alertController, animated: true)
//                }
//            }
//        }
//        
//    }
//    
//    @IBAction func bookmarkBtntapped(_ sender: UIBarButtonItem) {
//        viewModel!.isBookmarked = true
//        
//        let newsModel = viewModel
//        
//        let isNewsBookmarked = CoreDataManager.shared.checkAvailablityInBookmark(url: newsModel!.url!, selectedNewsCategory: selectedCategory! )
//        
//        if isNewsBookmarked {
//            //viewModels[indexPath]
//            CoreDataManager.shared.removeFromBookmarks(url: newsModel!.url!, selectedNewsCategory: selectedCategory!)
//            bookmarkbutton.image = UIImage(systemName:"bookmark" )
//        } else {
//            
//            CoreDataManager.shared.addToBookmarks(article: viewModel!, selectedcategory: selectedCategory!)
//            bookmarkbutton.image = UIImage(systemName:"bookmark.fill" )
//        }
//        delegate?.updateTableView()
//    }
//    
//    @IBAction func shareButtonTapped(_ sender: Any) {
//        let activityVC = UIActivityViewController(activityItems: [viewModel?.url], applicationActivities: nil)
//        activityVC.popoverPresentationController?.sourceView = self.view
//        self.present(activityVC, animated: true, completion: nil)
//    }
//    
//    
//    //MARK: -Helper Functions
//    func setUpDetailsView(){
//        if bookmarkBtnOpacity == 0 {
//            bookmarkbutton.isHidden = true
//        }
//        
//        title = viewModel?.source
//        
//        navigationController?.navigationBar.tintColor = .white
//        
//        setviewComponents()
//        
//        newsImageView.layer.cornerRadius = 20
//        newsImageView.clipsToBounds = true
//        newsImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        
//        detailsSubView.layer.cornerRadius = 20
//        detailsSubView.clipsToBounds = true
//        detailsSubView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//    }
//    
//    func isInternetAvailable(completion: @escaping (Bool)->()) {
//        guard let url = URL(string: "https://www.google.com") else { return completion(false)
//        }
//        let request = URLRequest(url: url)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            guard error == nil else {
//                completion(false)
//                return
//                
//            }
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completion(false)
//                return
//                
//            }
//            guard data != nil else { completion(false)
//                return
//            }
//            completion(true)
//        }
//        task.resume()
//    }
//    
//    
//    func setviewComponents(){
//        if let date = viewModel?.date {
//            let formattedDate = Constants.dateFormatter(date: date)
//            dateLabel.text = formattedDate
//        } else {
//            dateLabel.text = "Published time unknown!"
//        }
//        
//        contentLabel.text = viewModel?.content
//        newsTitleLabel.text = viewModel?.title
//        newDescription.text = viewModel?.newsDescription
//        
//        
//        if let data = viewModel?.imgData {
//            newsImageView.image = UIImage(data: data)
//        }
//        
//        else if let imgUrl = viewModel?.imgURL{
//            let url = URL(string: imgUrl)!
//            URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
//                guard let data = data, error==nil else{return}
//                
//                self?.viewModel?.imgData = data
//                DispatchQueue.main.async {
//                    self?.newsImageView.image = UIImage(data: data)
//                }
//                
//            }.resume()
//        }
//    }
//}
