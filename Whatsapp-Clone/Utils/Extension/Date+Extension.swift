//
//  Date+Extension.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 01/10/24.
//

import Foundation

extension Date {
    var dayOrTimeRepresentation: String {
        let calender = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calender.isDateInToday(self){
            dateFormatter.dateFormat = "HH:mm"
            let formattedDate = dateFormatter.string(from: self)
            return formattedDate
        }else if calender.isDateInYesterday(self){
            return "Yesterday"
        }else{
            dateFormatter.dateFormat = "dd/MM/YY"
            return dateFormatter.string(from: self)
        }
    }
    
    var formatToTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
    func toString(format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    var relativeDateString: String {
        let calender = Calendar.current
        if calender.isDateInToday(self){
            return "today"
        }
        else if calender.isDateInYesterday(self){
            return "yesterday"
        }
        else if isCurrentWeek{
            return toString(format: "EEEE") // monday
        }
        else if isCurrentYear{
            return toString(format: "E, MMM d") // mon, feb 19
        }
        else{
            return toString(format: "MMM dd, yyyy") // jun 02, 2004
        }
    }
    
    private var isCurrentWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekday)
    }
    
    private var isCurrentYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    func isSameDay(as otherDate: Date) -> Bool {
        let calander = Calendar.current
        return calander.isDate(self, inSameDayAs: otherDate)
    }
}
