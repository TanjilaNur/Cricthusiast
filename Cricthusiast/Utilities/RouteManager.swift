//
//  Routes.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 3/2/23.
//

import UIKit

class RouteManager {
    static let shared = RouteManager()
    private var routeMap: [String: UIViewController] = [:]
    
    var routes: [String: UIViewController] {
        get{
            setViewControllers()
            return routeMap
        }
    }
    
    
    private init() {
        setViewControllers()
    }
    
    private func setViewControllers(){
        // Gets the storyboard references
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let matchesStoryboard = UIStoryboard(name: "Matches", bundle: nil)
        let playersStoryboard = UIStoryboard(name: "Players", bundle: nil)
        let rankingStoryboard = UIStoryboard(name: "TeamRanking", bundle: nil)
        let moreStoryboard = UIStoryboard(name: "More", bundle: nil)
        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        let newsStoryboard = UIStoryboard(name: "News", bundle: nil)
        
        let tabBarController = CustomTabBarController()
        
        let detailsController = matchesStoryboard.instantiateViewController(withIdentifier: RouteConstants.matchDetailsViewControllerId)
        let playerDetailsController = playersStoryboard.instantiateViewController(withIdentifier: RouteConstants.playerDetailsViewControllerId)
        
        // Sets the view controllers based on constants
        routeMap = [
//            RouteConstants.homeViewControllerId: mainVC,
            RouteConstants.tabbarViewControllerId: tabBarController,
            RouteConstants.matchDetailsViewControllerId: detailsController,
            RouteConstants.playerDetailsViewControllerId: playerDetailsController
        ]
    }
}

class RouteConstants {
    static let initialViewControllerId = "InitialViewController"
    static let tabbarViewControllerId = "CustomTabBarController"
    static let homeViewControllerId = "HomeViewController"
    static let matchViewControllerId = "RecentMatchViewController"
    static let matchDetailsViewControllerId = "MatchDetailsViewController"
    static let matchInfoViewControllerId = "MatchInfoViewController"
    static let matchScorecardViewControllerId = "MatchScorecardViewController"
    static let matchOversViewControllerId = "MatchOversViewController"
    static let matchSquadsViewControllerId = "MatchSquadsViewController"
    static let playersViewControllerId = "PlayersViewController"
    static let playerDetailsViewControllerId = "PlayerDetailsViewController"
    static let newsViewControllerId = "NewsViewController"
    static let newsDetailsViewControllerId = "NewsDetailsViewController"
    static let settingsViewControllerId = "SettingsViewController"
    static let globalRankingViewControllerId = "RankingViewController"
}
