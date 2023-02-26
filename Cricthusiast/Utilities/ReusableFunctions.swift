//
//  File.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/15/23.
//

import UIKit

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

extension UIView {
    func setShadow(radius: CGFloat) {
        layer.shadowOpacity = 0.3
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowRadius = 2.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}

func findTimeDifference(from timeString: String) -> DateComponents? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    guard let time = formatter.date(from: timeString) else { return nil }
    
    let difference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: time)
    return difference
}

func findFormattedTimeInDC(from components: DateComponents?) -> String? {
    guard let components = components else { return nil }
    
    let outputFormatter = DateComponentsFormatter()
    outputFormatter.allowedUnits = [.day, .hour, .minute, .second]
    outputFormatter.maximumUnitCount = 7
    outputFormatter.unitsStyle = .full
    outputFormatter.zeroFormattingBehavior = .default
    
    return outputFormatter.string(from: components)
}

func formatTime(from timeString: String) -> String? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    guard let time = formatter.date(from: timeString) else { return nil }
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd-MM-yyyy, hh:mm a"
    outputFormatter.amSymbol = "AM"
    outputFormatter.pmSymbol = "PM"
    
    return outputFormatter.string(from: time)
}

func getCurrentDateTime() -> String {
    return Date.now.ISO8601Format()
}

func getTwentyDaysAgoDateTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let today = Date()
    let fifteenDaysAgo = Calendar.current.date(byAdding: .day, value: -20, to: today)!
    return fifteenDaysAgo.ISO8601Format()
}

func getThirtyDaysLaterDateTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let today = Date()
    let fifteenDaysAgo = Calendar.current.date(byAdding: .day, value: 30, to: today)!
    return formatter.string(from: fifteenDaysAgo)
}

func dateFormatter(date: String?) -> String {
        
    guard let date = date else {
        return ""
    }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let fetchedDate = formatter.date(from: date)
    
    let currentTime = Date.now
    
    let timeDifference = Calendar.current.dateComponents([.second], from: fetchedDate!, to: currentTime)
    let totalSeconds = timeDifference.second!
    
    let hour =  totalSeconds / 3600
    let minute = (totalSeconds % 3600) / 60
    
    return "🕒 \(hour == 0 ? "" : "\(hour)h") \(minute)m ago"

}
func convertToDateAndTime(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.locale = .current
    
    let timeFormatter = DateFormatter()
    timeFormatter.timeStyle = .short
    timeFormatter.locale = .current
    
    let localizedDateString = dateFormatter.string(from: date)
    let localizedTimeString = timeFormatter.string(from: date)
    
    return "\(localizedDateString) \(localizedTimeString)"
}
func predictWinningRate(totalGamesPlayed: Double, totalWins: Double, drawCount: Double) -> Double {
    let combinedScore = totalWins + (0.5 * drawCount)
    let winPercentage = combinedScore / totalGamesPlayed
    return winPercentage
}






