//
//  Routes.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 3/2/23.
//

import UIKit

class RouteManagerFactory {
    static let shared = RouteManagerFactory()
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
        let moreStoryboard = UIStoryboard(name: "More", bundle: nil)
        let newsStoryboard = UIStoryboard(name: "News", bundle: nil)
        let teamsStoryboard = UIStoryboard(name: "Teams", bundle: nil)
        let rankingStoryboard = UIStoryboard(name: "TeamRanking", bundle: nil)
        let dateWiseFixtureStoryboard = UIStoryboard(name: "DateWiseFixtures", bundle: nil)
        
        let tabBarController = CustomTabBarController()
        
        let detailsController = matchesStoryboard.instantiateViewController(withIdentifier: RouteConstants.matchDetailsViewControllerId)
        
        let playerDetailsController = playersStoryboard.instantiateViewController(withIdentifier: RouteConstants.playerDetailsViewControllerId)
        
        let newsViewController = newsStoryboard.instantiateViewController(withIdentifier: RouteConstants.newsViewControllerId)
        
        let rankingViewController = rankingStoryboard.instantiateViewController(withIdentifier: RouteConstants.rankingViewControllerId)
        
        let teamsViewController = teamsStoryboard.instantiateViewController(withIdentifier: RouteConstants.teamsViewControllerId)
        
        let teamSquadViewController = teamsStoryboard.instantiateViewController(withIdentifier: RouteConstants.teamSquadViewControllerId)
        
        let newsWebViewController = newsStoryboard.instantiateViewController(withIdentifier: RouteConstants.newsWebViewControllerId)
        
        let notificationViewController = homeStoryboard.instantiateViewController(withIdentifier: RouteConstants.notificationViewControllerId)
        
        let matchDateViewController = dateWiseFixtureStoryboard.instantiateViewController(withIdentifier: RouteConstants.matchDateViewControllerId)
    
        // Sets the view controllers based on constants
        routeMap = [
            RouteConstants.tabbarViewControllerId: tabBarController,
            
            RouteConstants.matchDetailsViewControllerId: detailsController,
            
            RouteConstants.playerDetailsViewControllerId: playerDetailsController,
            
            RouteConstants.newsViewControllerId: newsViewController,
                    
            RouteConstants.teamsViewControllerId: teamsViewController,
            
            RouteConstants.rankingViewControllerId: rankingViewController,
            
            RouteConstants.teamSquadViewControllerId: teamSquadViewController,
                        
            RouteConstants.newsWebViewControllerId: newsWebViewController,
            
            RouteConstants.notificationViewControllerId: notificationViewController,
            
            RouteConstants.matchDateViewControllerId: matchDateViewController
            
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
    static let matchSquadsViewControllerId = "MatchSquadsViewController"
    
    static let playersViewControllerId = "PlayersViewController"
    static let playerDetailsViewControllerId = "PlayerDetailsViewController"
    static let playerInfoViewControllerId = "PlayerInfoViewController"
    static let playerTeamsViewControllerId = "PlayerTeamsViewController"
    static let PlayerStatViewControllerId = "PlayerStatViewController"
    
    static let moreViewControllerId = "MoreViewController"
    
    static let newsViewControllerId = "NewsViewController"
    static let newsWebViewControllerId = "NewsWebViewController"
    
    static let teamsViewControllerId = "TeamsViewController"
    static let teamSquadViewControllerId = "TeamSquadViewController"
    
    static let rankingViewControllerId = "RankingViewController"
    
    static let notificationViewControllerId = "NotificationViewController"
    
    static let matchDateViewControllerId = "MatchDateViewController"
}
