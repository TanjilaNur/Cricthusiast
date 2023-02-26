//
//  CustomTabBarController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 11/2/23.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [generateHomeVC(),generateMatchesVC(),generatePlayersVC(),generateMoreVC()]
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 10, y: self.tabBar.bounds.minY-3, width: self.tabBar.bounds.width - 20, height: self.tabBar.bounds.height + 10), cornerRadius: (self.tabBar.frame.width/2)).cgPath
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 25.0
        layer.shadowOpacity = 0.5
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor(named: "primary")?.cgColor
        
        self.tabBar.layer.insertSublayer(layer, at: 0)
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .systemGray3
        
        //        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        var bottomPadding = window?.safeAreaInsets.bottom
        
        
        bottomPadding = bottomPadding ?? 10 > 0 ? 0.0 : 25.0
        
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding! , right: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func generateHomeVC() -> UIViewController {
        //let vc = RouteManager.shared.routes[RouteConstants.mainViewControllerId]!
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: RouteConstants.homeViewControllerId) as! HomeViewController
        vc.title = "Main"
        vc.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house.fill"), tag: 0)
        return vc
        
    }
    
    func generateMatchesVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Matches", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: RouteConstants.matchViewControllerId) as! MatchViewController
        
        vc.title = "Matches"
        vc.tabBarItem = UITabBarItem(title: "Matches", image: UIImage(systemName: "cricket.ball.circle"), tag: 1)
        return vc
    }
    
    func generatePlayersVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Players", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: RouteConstants.playersViewControllerId) as! PlayersViewController
        
        vc.title = "Players"
        vc.tabBarItem = UITabBarItem(title: "Players", image: UIImage(systemName: "person.2.fill"), tag: 1)
        return vc
    }
    
    func generateMoreVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: RouteConstants.moreViewControllerId) as! MoreViewController
        
        vc.title = "More"
        vc.tabBarItem = UITabBarItem(title: "More", image: UIImage(systemName: "ellipsis"), tag: 1)
        return vc
    }
    
}
