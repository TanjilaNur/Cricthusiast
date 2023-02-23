//
//  NewsViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/14/23.
//

//import UIKit
//import CoreData
//
//protocol UpdateBookmarks {
//    func updateTableView()
//}
//
//class NewsViewController: UIViewController {
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    @IBOutlet weak var topLabel: UILabel!
//
//    @IBOutlet weak var searchTextField: UITextField!
//
//    @IBOutlet weak var tableView: UITableView!
//
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    @IBOutlet weak var tabView: UIView!
//
//    var articles = [News]()
//
//    var viewModels = [TableViewCellViewModel]()
//
//    var selectedNewsCategory:CategoryList = .all
//
//    var selectedIndexPath: IndexPath = [0,0]
//
//    var offset = 0
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        autoRefreshApp()
//        fetchNews()
//
//        setUpViews()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        fetchNews()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        searchTextField.text = ""
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == Constants.goToDetailsView {
//            if let vc = segue.destination as? DetailsViewController {
//                vc.delegate = self
//
//                //Passing Necessary data for DetailsViewController
//                let viewModel = viewModels[selectedIndexPath.row]
//                vc.viewModel = viewModel
//                vc.selectedCategory = selectedNewsCategory
//                vc.indexPath = selectedIndexPath
//            }
//        }
//    }
//
//    @IBAction func searchFieldTypingChanged(_ sender: UITextField) {
//        fetchNews()
//    }
//
//    @objc private func didPullToRefresh(){
//        articles = CoreDataManager.shared.deleteAllRecordsFromCoredata()
//        //  viewModels = []
//        fetchNews()
//
//        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//            self.tableView.refreshControl?.endRefreshing()
//        }
//    }
//
//    fileprivate func setUpTableView() {
//        tableView.dataSource = self
//        tableView.delegate = self
//
//        tableView.refreshControl = UIRefreshControl()
//        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
//
//        tableView.layer.cornerRadius = 30
//        tableView.clipsToBounds = true
//        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//
//        tabView.layer.cornerRadius = 30
//        tabView.clipsToBounds = true
//
//        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCellForNews")
//    }
//
//    fileprivate func setUpCollectionView() {
//        collectionView.dataSource = self
//        collectionView.delegate = self
//
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize  = CGSize(width: 125, height: 35)
//        layout.scrollDirection = .horizontal
//        collectionView.collectionViewLayout = layout
//
//        let nib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: "CustomCollectionViewCell")
//    }
//
//    func setUpViews(){
//        topLabel.text = "News Today"
//        setSearchBarImage()
//        setUpCollectionView()
//        setUpTableView()
//        searchTextField.placeholder = ""
//    }
//
//    func setSearchBarImage(){
//        let searchIcon  = UIImageView()
//        searchIcon.image = UIImage(systemName: "magnifyingglass")
//        let uiView = UIView()
//        uiView.addSubview(searchIcon)
//        uiView.frame = CGRect(x: 10, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width+15, height: UIImage(systemName: "magnifyingglass")!.size.height)
//
//        searchIcon.frame = CGRect(x: 10, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width, height: UIImage(systemName: "magnifyingglass")!.size.height)
//
//        searchTextField.leftView = uiView
//        searchTextField.clearButtonMode = .whileEditing
//        searchTextField.leftViewMode = .always
//    }
//
//
//    func autoRefreshApp() {
//
//        let currentDate = Date()
//        let lastUpdatedTime:Int64 = UserDefaults.standard.value(forKey: "lastUpdateTime") as? Int64 ?? 0
//        let currentTime = Int64(currentDate.timeIntervalSince1970 * 1000)
//        let dateDiffrence = currentTime - lastUpdatedTime
//
//        if dateDiffrence >= 3*60*60*1000 {
//            didPullToRefresh()
//            UserDefaults.standard.setValue(currentTime, forKey: "lastUpdateTime")
//        }
//    }
//
//    func fetchNews() {
////        loadingLabel.alpha = 1
//        tableView.alpha = 0
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
//        self.tableView.alpha = 1
//        self.tableView.reloadData()
//    }
//}
//
//
//
//
//extension NewsViewController: UpdateBookmarks {
//    func updateTableView(){
//        tableView.reloadData()
//    }
//}
//
////MARK: -UICollectionViewDataSource
//extension NewsViewController : UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return CategoryList.allCases.count
//    }
//
//    fileprivate func markSelectedCell(_ cell: CustomCollectionViewCell) {
//        cell.selectionView.backgroundColor = .white
//        cell.categoryLabel.backgroundColor = UIColor(named: "navy")
//        cell.selectionView.layer.cornerRadius = cell.selectionView.frame.height / 2
//        cell.categoryLabel.alpha = 1
//    }
//
//    fileprivate func markAsUnselectedCell(_ cell: CustomCollectionViewCell) {
//        cell.selectionView.backgroundColor = UIColor(named: "navy")
//        cell.categoryLabel.backgroundColor = UIColor(named: "navy")
//        cell.categoryLabel.alpha = 0.6
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
//
//        let item = CategoryList.allCases[indexPath.row]
//
//        if item == selectedNewsCategory{
//            markSelectedCell(cell)
//
//        } else {
//            markAsUnselectedCell(cell)
//        }
//
//        cell.categoryLabel.text = item.rawValue.capitalized
//
//        return cell
//    }
//}
//
//
////MARK: - UICollectionViewDelegate
//extension NewsViewController : UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //        print(indexPath)
//        selectedNewsCategory = CategoryList.allCases[indexPath.row]
//        print("///////////////////\(selectedNewsCategory)")
//        fetchNews()
//        collectionView.reloadData()
//    }
//}
//
//
////MARK: - UICollectionViewDelegateFlowLayout
//extension NewsViewController: UICollectionViewDelegateFlowLayout
//{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: 125, height: 35)
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



    

