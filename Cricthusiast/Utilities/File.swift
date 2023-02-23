//
//  File.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/15/23.
//

import UIKit


func predictWinningRate(totalGamesPlayed: Double, totalWins: Double, drawCount: Double) -> Double {
    let combinedScore = totalWins + (0.5 * drawCount)
    let winPercentage = combinedScore / totalGamesPlayed
    return winPercentage
}

extension Double {
    
    func roundedNumber() -> Double {
        let power = pow(10, Double(2))
       return (self * power).rounded() / power
    }
}

extension UISegmentedControl
{
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.white) {
        let defaultAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }

    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 12), color: UIColor = UIColor(.red)) {
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
