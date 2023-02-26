//
//  ViewController.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 3/2/23.
//

import UIKit
import Combine
class InitialViewController: UIViewController {
    
    let viewModel = PlayersViewModel()
    var cancellables : Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationHandler.getAllPendingNotification { notifications in
            print("PENDING NOTIFICATIONS")
            dump(notifications)
        }
        
        
        viewModel.fetchPlayersData()
        setupBinders()
        print("")
        
    }
    
    func setupBinders() {
        viewModel.$isFetchingCompleted.sink {[weak self] isFetchingCompleted in
            
            guard let self = self else { return }
            
            if isFetchingCompleted {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.navigationController?.pushViewController(RouteManagerFactory.shared.routes[RouteConstants.tabbarViewControllerId]!, animated: true)
                }
            }
        }.store(in: &cancellables)
        //        viewModel.$playerList.sink {[weak self] players in
        //
        //            guard let self = self else { return }
        //
        //            if !players.isEmpty {
        //                DispatchQueue.main.async {
        //                    self.navigationController?.pushViewController(RouteManager.shared.routes[RouteConstants.tabbarViewControllerId]!, animated: true)
        //                }
        //            }
        //        }.store(in: &cancellables)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.viewControllers.removeAll(where: { viewController in
            viewController == self
        })
    }
    
    
}

