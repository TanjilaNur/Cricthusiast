//
//  MainViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 3/2/23.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var actTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var cvTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tvTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var appTitleView: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var newsTableView: UITableView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var articles = [ArticleModel]()
    
    var featuredMatchModels : [MatchCellModel] = []
    
    var selectedNewsCategory:CategoryList = .all
    
    var selectedIndexPath: IndexPath = [0,0]
    
    var offset = 0
    
    var viewModel = HomeViewModel()
    
    var cancellables: Set<AnyCancellable> = []
    
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
        layout.itemSize  = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 0.98)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        
        // set up page control
        pageControl.numberOfPages = featuredMatchModels.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        
        topView.clipsToBounds = true
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        topView.layer.cornerRadius = 20
        
        appTitleView.layer.cornerRadius = 15
        
        collectionView.register(UINib(nibName: "FeaturedMatchesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedMatchesCollectionViewCell")
        
        newsTableView.register(UINib(nibName: NewsTableViewCell.id, bundle: nil), forCellReuseIdentifier: NewsTableViewCell.id)
        
        newsTableView.register(UINib(nibName: NewsTableViewCellTwo.id, bundle: nil), forCellReuseIdentifier: NewsTableViewCellTwo.id)
        viewModel.getHomePageData()
        setupBinder()
    }
    
    @objc func pageControlValueChanged() {
        let currentPage = pageControl.currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize  = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 0.98)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
    }
    
    func setupBinder() {
        viewModel.$isRecentLoading.sink {[weak self] isLoading in
            
            guard let self = self else { return }
            
            if (!isLoading) {
            
                self.featuredMatchModels = self.viewModel.liveMatches + self.viewModel.twoUpcoming + self.viewModel.threeRecent
                self.pageControl.numberOfPages = self.featuredMatchModels.count
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }.store(in: &cancellables)
        
        viewModel.$isUpcomingLoading.sink {[weak self] isLoading in
            
            guard let self = self else { return }
            
            if (!isLoading) {
                self.featuredMatchModels = self.viewModel.liveMatches + self.viewModel.twoUpcoming + self.viewModel.threeRecent
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }.store(in: &cancellables)
        
        
        viewModel.$isLiveLoading.sink {[weak self] isLoading in
            
            guard let self = self else { return }
            
            if (!isLoading) {
                self.featuredMatchModels = self.viewModel.liveMatches + self.viewModel.twoUpcoming + self.viewModel.threeRecent
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
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
                    self.viewModel.fetchFeaturedFixture()
                }

                alertController.addAction(okayAction)
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true)
            }
        }.store(in: &cancellables)
        
        viewModel.$isNewsLoading.sink {[weak self] isNewsLoading in
            
            guard let self = self else { return }
            
            if (!isNewsLoading) {
                self.articles = self.viewModel.articles
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                }
            }
        }.store(in: &cancellables)
    }

    @IBAction func notificationBtnTapped(_ sender: UIButton) {
        guard let notificationVC = RouteManagerFactory.shared.routes[RouteConstants.notificationViewControllerId] as? NotificationViewController else { return }
        
        navigationController?.pushViewController(notificationVC, animated: true)
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
        
        if dateDiffrence >= 1*60*60*1000 {
            self.viewModel.getHomePageData()
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
    
}

//MARK: -UICollectionViewDataSource
extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featuredMatchModels.count
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
        
        
        let model = featuredMatchModels[indexPath.row]
        
        cell.setValues(model: model)
        
        
        return cell
    }
    func shareButtonTapped(url: String) {
        
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
}

//MARK: - UICollectionViewDelegate
extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailsVC = RouteManagerFactory.shared.routes[RouteConstants.matchDetailsViewControllerId] as? MatchDetailsViewController else { return }
        detailsVC.id = featuredMatchModels[indexPath.row].id
        navigationController?.pushViewController(detailsVC, animated: true)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
                self.tvTopConstraint.constant = 217
                self.cvTopConstraint.constant = 55
                self.actTopConstraint.constant = 140
                
                self.view.layoutIfNeeded()
            } else if (scrollView.contentOffset.y > 100) {
                self.tvTopConstraint.constant = 10
                self.cvTopConstraint.constant = -315
                self.actTopConstraint.constant = -100
                self.view.layoutIfNeeded()
            }
        }
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 6 == 0 {
            let cell = newsTableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.id, for: indexPath) as! NewsTableViewCell
            let model = articles[indexPath.row]
            
            cell.imgView.sd_setImage(with: URL(string: model.urlToImage ?? ""), placeholderImage: UIImage(systemName: "photo"), options: .progressiveLoad)
            cell.newsTitleLabel.text = model.title
            cell.publishedTimeLabel.text = dateFormatter(date: model.publishedAt)
            
            cell.imgView.layer.cornerRadius = 20
            return cell
        } else {
            let cell = newsTableView.dequeueReusableCell(withIdentifier: NewsTableViewCellTwo.id, for: indexPath) as! NewsTableViewCellTwo
            let model = articles[indexPath.row]
            cell.imgView.sd_setImage(with: URL(string: model.urlToImage ?? ""), placeholderImage: UIImage(systemName: "photo"), options: .progressiveLoad)
            cell.title.text = model.title
            cell.pubTime.text = "\(dateFormatter(date: model.publishedAt))"
            
            return cell
        }
    }
}


//MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsVC = RouteManagerFactory.shared.routes[RouteConstants.newsWebViewControllerId] as? NewsWebViewController else { return }
        
        detailsVC.url = articles[indexPath.row].url
        
        navigationController?.pushViewController(detailsVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }


    //MARK: Trailing Swipe Action(Delete)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let shareAction = UIContextualAction(style: .destructive , title: nil) { [weak self] _,_,completion in

            guard let self = self else {return}

            let articleURL = self.articles[indexPath.row].url
            self.shareButtonTapped(url: articleURL ?? "")

            completion(true)
        }

        shareAction.image = UIImage(systemName: "square.and.arrow.up.fill")
        shareAction.backgroundColor = .systemBlue

        let swipeAction = UISwipeActionsConfiguration(actions: [shareAction])
        swipeAction.performsFirstActionWithFullSwipe = true
        return swipeAction
    }
}


