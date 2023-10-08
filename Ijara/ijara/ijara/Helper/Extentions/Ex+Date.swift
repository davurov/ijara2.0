//
//  Ex+Date.swift
//  ijara
//
//  Created by Abduraxmon on 27/09/23.
//

import Foundation
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    static var morning: Date {return Date().morning}
    static var night: Date {return Date().night}
    static var currentHour : Int {return Date().currentHour}
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var morning: Date {
        return Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: self)!
    }
    var night: Date {
        return Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: self)!
    }
    
    var currentHour: Int {
        return Calendar.current.component(.hour, from: Date())
    }
    
    var currentDay: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var currentYear: Int {
        return Calendar.current.component(.year, from: Date())
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
