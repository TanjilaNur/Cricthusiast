//
//  MainViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 3/2/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var cvTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cvleftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tvTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var appTitleView: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var newsTableView: UITableView!
    
    
    var articles = [ArticleModel]()
    
    var viewModels = [NewsTableViewCellModel]()
    
    var featuredMatchModels : [MatchCellModel] = []
    
    var selectedNewsCategory:CategoryList = .all
    
    var selectedIndexPath: IndexPath = [0,0]
    
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        autoRefreshApp()
        //fetchNews()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        newsTableView.refreshControl = UIRefreshControl()
        newsTableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        
        newsTableView.layer.opacity = 1
        newsTableView.layer.cornerRadius = 30
        newsTableView.clipsToBounds = true
        newsTableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        newsTableView.layer.cornerRadius = 20
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize  = CGSize(width: collectionView.bounds.width * 0.85 , height: collectionView.bounds.height * 0.95)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = collectionView.bounds.width * 0.102
        collectionView.collectionViewLayout = layout
        
        topView.clipsToBounds = true
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        topView.layer.cornerRadius = 25
        
        appTitleView.layer.cornerRadius = 15
        
        collectionView.register(UINib(nibName: "FeaturedMatchesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedMatchesCollectionViewCell")
        
        newsTableView.register(UINib(nibName: NewsTableViewCell.id, bundle: nil), forCellReuseIdentifier: NewsTableViewCell.id)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //fetchNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func autoRefreshApp() {
        
        let currentDate = Date()
        let lastUpdatedTime:Int64 = UserDefaults.standard.value(forKey: "lastUpdateTime") as? Int64 ?? 0
        let currentTime = Int64(currentDate.timeIntervalSince1970 * 1000)
        let dateDiffrence = currentTime - lastUpdatedTime
        
        if dateDiffrence >= 3*60*60*1000 {
            didPullToRefresh()
            UserDefaults.standard.setValue(currentTime, forKey: "lastUpdateTime")
        }
    }
    
    @objc private func didPullToRefresh(){
        //fetchNews()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.newsTableView.refreshControl?.endRefreshing()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    //    func fetchNews() {
    //        newsTableView.alpha = 0
    //
    //        let newsesOfCoreData = CoreDataManager.shared.getMatchedRecords(query: "", category: selectedNewsCategory)
    //
    //        if newsesOfCoreData.count == 0 {
    //            APICaller.shared.fetchDataFromAPI(query: searchTextField.text ?? "",category: selectedNewsCategory){ [weak self] result in
    //
    //                guard let self = self else{ return }
    //
    //                switch result{
    //                case .success(let articles):
    //                    DispatchQueue.main.async {
    //                        self.tableView.alpha = 0
    //                        let savedNewsModels = CoreDataManager.shared.addToCoredata(articles: articles, category: self.selectedNewsCategory)
    //
    //                        self.articles = savedNewsModels
    //
    //                        self.createViewModelFromArticles()
    //                    }
    //                case .failure(let error):
    //                    DispatchQueue.main.async {
    //                        print(error)
    //                        let alertController = UIAlertController(title: "Error occured!", message: "Please check connectivity or try again later!", preferredStyle: .alert)
    //
    //                        let okayAction = UIAlertAction(title: "OK!", style: .default)
    //
    //                        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { [weak self]_ in
    //                            guard let self = self else { return }
    //                            self.fetchNews()
    //                        }
    //
    //                        alertController.addAction(okayAction)
    //                        alertController.addAction(tryAgainAction)
    //                        self.present(alertController, animated: true)
    //                    }
    //                }
    //            }
    //
    //        } else {
    //            self.articles = CoreDataManager.shared.getMatchedRecords(query: searchTextField.text ?? "", category: selectedNewsCategory)
    //
    //            self.createViewModelFromArticles()
    //        }
    //    }
    //
    //    func createViewModelFromArticles(){
    //        self.viewModels = self.articles.compactMap({
    //            TableViewCellViewModel(source:$0.sourceName ?? "No Source!",
    //                                   title: $0.title ?? "No Title!",
    //                                   description: $0.newsDescription ?? "",
    //                                   content: $0.content ?? "No content!",
    //                                   author: $0.author ?? "Unknown Author!",
    //                                   imgURL:$0.urlToImage ?? "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg",
    //                                   url: $0.url ?? "",
    //                                   date: $0.publishedAt ?? "Date Unknown!",
    //                                   isBookmarked: false
    //            )
    //        })
    //
    //        //                     self.loadingLabel.alpha = 0
    //        self.newsTableView.alpha = 1
    //        self.newsTableView.reloadData()
    //    }
}

//MARK: -UICollectionViewDataSource
extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    //    fileprivate func markSelectedCell(_ cell: CollectionViewCell) {
    //        cell.selectionView.backgroundColor = .white
    //        cell.categoryLabel.backgroundColor = UIColor(named: "navy")
    //        cell.selectionView.layer.cornerRadius = cell.selectionView.frame.height / 2
    //        cell.categoryLabel.alpha = 1
    //    }
    
    fileprivate func markAsUnselectedCell(_ cell: FeaturedMatchesCollectionViewCell) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedMatchesCollectionViewCell", for: indexPath) as! FeaturedMatchesCollectionViewCell
        
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
extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailsVC = RouteManager.shared.routes[RouteConstants.matchDetailsViewControllerId] as? MatchDetailsViewController else { return }
        detailsVC.id = featuredMatchModels[indexPath.row].id
        navigationController?.pushViewController(detailsVC, animated: true)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout
{
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        return CGSize(width: 250, height: 180)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (collectionView.bounds.width * 0.076), bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
//MARK: -ScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.5, delay: 0) {[weak self] in
            guard let self = self else {
                return
            }
            if (scrollView.contentOffset.y < 100) {
                print("Scrolled up")
                
                self.tvTopConstraint.constant = 217
                self.cvTopConstraint.constant = 55
                self.cvleftConstraint.constant = 0
                self.view.layoutIfNeeded()
                
            } else if (scrollView.contentOffset.y > 100) {
                print("Scrolled down")
                self.tvTopConstraint.constant = 10
                self.cvTopConstraint.constant = -315
                self.cvleftConstraint.constant = self.view.frame.width
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.id, for: indexPath) as! NewsTableViewCell
        
        cell.imgView.image = UIImage(named: "colorful")
        cell.newsTitleLabel.text = "Be patient! The project is about to be ended very soon."
        cell.publishedTimeLabel.text = "02/18/2023, 8:00 AM"
        
        cell.imgView.layer.cornerRadius = 20
        
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate{
    
}
//MARK: - FOR NEWS
//extension HomeViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print(indexPath)
//
//        if indexPath.row == (articles.count-1){
//            offset = offset + 10
//            articles.append(contentsOf: CoreDataManager.shared.getMatchedRecords(offset: offset, query: searchTextField.text ?? "", category: selectedNewsCategory))
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        selectedIndexPath = indexPath
//        performSegue(withIdentifier: Constants.goToDetailsView , sender: self)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//
//    //MARK: Trailing Swipe Action(Delete)
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let bookmarkAction = UIContextualAction(style: .destructive , title: nil) { [weak self] _,_,completion in
//
//            guard let self = self else {return}
//
//            let newsModel = self.viewModels[indexPath.row]
//
//            let isNewsBookmarked = CoreDataManager.shared.checkAvailablityInBookmark(url: newsModel.url!, selectedNewsCategory: self.selectedNewsCategory)
//
//            if isNewsBookmarked {
//                CoreDataManager.shared.removeFromBookmarks(url: newsModel.url!, selectedNewsCategory: self.selectedNewsCategory)
//            } else {
//                CoreDataManager.shared.addToBookmarks(article: self.viewModels[indexPath.row], selectedcategory: self.selectedNewsCategory)
//            }
//            tableView.reloadData()
//
//            completion(true)
//        }
//
//        bookmarkAction.image = UIImage(systemName: "bookmark.fill")
//        bookmarkAction.backgroundColor = .systemOrange
//
//        let shareAction = UIContextualAction(style: .destructive , title: nil) { [weak self] _,_,completion in
//
//            guard let self = self else {return}
//
//            let articleURL = self.viewModels[indexPath.row].url
//            self.shareButtonTapped(url: articleURL ?? "")
//
//            completion(true)
//        }
//
//        shareAction.image = UIImage(systemName: "square.and.arrow.up.fill")
//        shareAction.backgroundColor = .systemBlue
//
//        let swipeAction = UISwipeActionsConfiguration(actions: [bookmarkAction, shareAction])
//        swipeAction.performsFirstActionWithFullSwipe = true
//        return swipeAction
//    }
//
//    func shareButtonTapped(url: String) {
//        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//        activityVC.popoverPresentationController?.sourceView = self.view
//        self.present(activityVC, animated: true, completion: nil)
//    }
//}
//
//extension HomeViewController: UITableViewDataSource {
//    //    MARK: Row Count
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return viewModels.count
//    }
//
//    //    MARK: TAble View Cell
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCellForNews", for: indexPath) as! NewsTableViewCell
//
//        cell.setValues(viewModel: viewModels[indexPath.row])
//
//        cell.bookmarkImgView.alpha = CoreDataManager.shared.checkAvailablityInBookmark(url: viewModels[indexPath.row].url!, selectedNewsCategory: self.selectedNewsCategory) ? 1 : 0
//
//        cell.bookmarkBGView.alpha = CoreDataManager.shared.checkAvailablityInBookmark(url: viewModels[indexPath.row].url!, selectedNewsCategory: self.selectedNewsCategory) ? 0.25 : 0
//
//
//        cell.newsImageView.layer.cornerRadius = 20
//
//        return cell
//    }
//}

