//
//  GlobalTeamRankingViewModel.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 22/2/23.
//

import Foundation

class GlobalTeamRankingViewModel {
    @Published var isLoading = false
    @Published var error: Error?
    
    var rankingTeamModels:[RankTVCellModel] = []
    
    func fetchGlobalRanking(type: String) {
        isLoading = true
        ServiceHandler.shared.fetchGlobalRanking(type: type) {[weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let matchType = data?.first(where: {
                    $0.gender == "men"
                })
                self.rankingTeamModels = matchType?.team?.compactMap({
                    RankTVCellModel(
                        rank: $0.position ?? -1,
                        country: $0.name ?? "N/A",
                        countryFlagUrl: $0.imagePath ?? "",
                        matchCount: $0.ranking?.matches ?? -1,
                        Rating: $0.ranking?.rating ?? -1,
                        points: $0.ranking?.points ?? -1)
                }) ?? []
                
                self.isLoading = false
                
            case .failure(let error):
                print(error)
                self.isLoading = false
                self.error = error
            }
        }
    }
    
}
