//
//  Item.swift
//  SpendKeeper
//
//  Created by Mehmet Jiyan Atalay on 19.07.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    let month: Int
    let year: Int
    var spendings: [Spendings] = []
    var totalSpendings = 0
    
    init(month: Int, year: Int) {
        self.month = month
        self.year = year
    }
    
    static func getCurrentMonth() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.component(.month, from: currentDate)
    }
        
    static func getCurrentYear() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: currentDate)
    }
    
    func getMonthName() -> String? {
        let locale = Locale(identifier: "tr_TR")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "MMMM"

        var components = DateComponents()
        components.month = month

        let calendar = Calendar.current
        if let date = calendar.date(from: components) {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

struct Spendings : Codable, Identifiable {
    var id = UUID()
    var amount: Int
    var description: String
    var day : Int
}
