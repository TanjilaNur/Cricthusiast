//
//  PlayerDetailsViewModel.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 19/2/23.
//

import Foundation

struct PlayerPersonalInfoModel {
    let name: String
    let country: String
    let imgUrl: String
    let cfImgUrl: String
    
    let dob: String
    let birthPlace: String
    let nickName: String
    let role: String
    let battingStyle: String
    let bowlingStyle: String
}

class PlayerDetailsViewModel {
    @Published var isLoading = false
    //Info
    var info: PlayerPersonalInfoModel?
    //Career
    var battingData: [PlayerBattingCareerModel] = []
    var bowlingData: [PlayerBowlingCareerModel] = []
    //Teams
    var allTeams: [Team] = []
    var currentTeams: [Team] = []
    
    func fetchCareerInfo(id: Int) {
        isLoading = true
        ServiceHandler.shared.fetchPlayerById(id: id) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let careerData = data?.career else { return }
                for cD in careerData {
                    guard let battingData = cD.batting else { continue }
                    
                    let battingCareerData = PlayerBattingCareerModel(
                        title: cD.type ?? "N/A",
                        matches: "\(battingData["matches"]??.roundedNumber().description ?? "N/A")\n Matches",
                        season: (String(cD.updatedAt?.description.prefix(4) ?? "N/A")),
                        innings: "\(battingData["innings"]??.roundedNumber().description ?? "N/A")\n Inn.",
                        score: "\(battingData["runs_scored"]??.roundedNumber().description ?? "N/A") \n Score",
                        highestInningScore: "\(battingData["highest_inning_score"]??.description ?? "N/A") \n HIS",
                        strikeRate: "\(battingData["strike_rate"]??.roundedNumber().description ?? "N/A")\n SR",
                        ballsFaced: "\(battingData["balls_faced"]??.roundedNumber().description ?? "N/A")\n BF",
                        average: "\(battingData["average"]??.roundedNumber().description ?? "N/A")\n Avg.",
                        six_x: "\(battingData["six_x"]??.roundedNumber().description ?? "N/A")\n Sixs",
                        four_x: "\(battingData["four_x"]??.roundedNumber().description ?? "N/A")\n Fours",
                        hundreds: "\(battingData["hundreds"]??.roundedNumber().description ?? "N/A")\n Cent.",
                        fifties: "\(battingData["fifties"]??.roundedNumber().description ?? "N/A")\n H.Cent.",
                        fowScore: "\(battingData["fow_score"]??.roundedNumber().description ?? "N/A")\n FOW")
                  
                    
                    self.battingData.append(battingCareerData)
                    
                    guard let bowlingData = cD.bowling else { continue }

                    let bowlingCareerData = PlayerBowlingCareerModel(
                        title: cD.type ?? "N/A",
                        matches:"\(bowlingData["matches"]??.roundedNumber().description ?? "N/A")\n Matches",
                        season: (String(cD.updatedAt?.description.prefix(4) ?? "N/A")),
                        overs: "\(bowlingData["overs"]??.roundedNumber().description ?? "N/A")\n Over",
                        innings: "\(bowlingData["innings"]??.roundedNumber().description ?? "N/A")\n Inn.",
                        average: "\(bowlingData["average"]??.roundedNumber().description ?? "N/A") \n Avg.",
                        econRate: "\(bowlingData["econ_rate"]??.roundedNumber().description ?? "N/A") \n E.R.",
                        medians: "\(bowlingData["medians"]??.roundedNumber().description ?? "N/A")\n Med.",
                        runs: "\(bowlingData["balls_faced"]??.roundedNumber().description ?? "N/A")\n Runs",
                        wickets: "\(bowlingData["wickets"]??.roundedNumber().description ?? "N/A")\n Wick.",
                        wide: "\(bowlingData["wide"]??.roundedNumber().description ?? "N/A")\n Wide",
                        noBall: "\(bowlingData["noball"]??.roundedNumber().description ?? "N/A")\n No Ball",
                        strikeRate: "\(bowlingData["strike_rate"]??.roundedNumber().description ?? "N/A")\n S.R.",
                        rate: "\(bowlingData["rate"]??.roundedNumber().description ?? "N/A")\n Rate")
                  
                    self.bowlingData.append(bowlingCareerData)
                    
                }
                self.isLoading = false
            case .failure(let error):
                print(error)
                self.isLoading = false
            }
        }
    }
    func fetchInfo(id: Int) {
        isLoading = true
        ServiceHandler.shared.fetchPlayerById(id: id) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.info =
                PlayerPersonalInfoModel(
                    name: data?.fullname ?? "N/A",
                    country: data?.country?.name ?? "N/A",
                    imgUrl:data?.imagePath ?? "" ,
                    cfImgUrl: data?.country?.imagePath ?? "N/A",
                    dob: data?.dateofbirth ?? "",
                    birthPlace: data?.country?.name ?? "N/A",
                    nickName: data?.lastname ?? "N/A",
                    role: data?.position?.name ?? "N/A",
                    battingStyle: data?.battingstyle ?? "N/A",
                    bowlingStyle: data?.bowlingstyle ?? "N/A")
                self.isLoading = false
            case .failure(let error):
                print(error)
                self.info =
                PlayerPersonalInfoModel(
                    name: "N/A",
                    country: "N/A",
                    imgUrl: "" ,
                    cfImgUrl: "N/A",
                    dob: "N/A",
                    birthPlace: "N/A",
                    nickName: "N/A",
                    role: "N/A",
                    battingStyle: "N/A",
                    bowlingStyle: "N/A")
                self.isLoading = false
            }
        }
    }
    
    func fetchTeams(id: Int) {
        isLoading = true
        ServiceHandler.shared.fetchPlayerById(id: id) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                //all
                guard let aTeams = data?.teams  else { return }
                for team in aTeams {
                    let doesTeamExist = self.allTeams.contains { t in
                        team.id == t.id
                    }
                    if (!doesTeamExist) {
                        self.allTeams.append(team)
                    }
                }
                //Current
                guard let cTeams = data?.currentteams  else { return }
                for team in cTeams {
                    let doesTeamExist = self.currentTeams.contains { t in
                        team.id == t.id
                    }
                    if (!doesTeamExist) {
                        self.currentTeams.append(team)
                    }
                }
                self.isLoading = false
            case .failure(let error):
                print(error)
                self.allTeams = []
                self.currentTeams = []
            }
        }
    }
    
}
