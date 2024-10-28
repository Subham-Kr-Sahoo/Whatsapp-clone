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
}
