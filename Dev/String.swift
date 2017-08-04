//
//  String.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 2/12/16.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension Date {
    
    func toString (format:String) -> String? {
        return DateFormatter(format: format).string(from: self)
    }
}

extension String {
    func contains(string: String)->Bool {
        guard !self.isEmpty else {
            return false
        }
        var s = self.characters.map{ $0 }
        let c = string.characters.map{ $0 }
        repeat {
            if s.starts(with: c){
                return true
            } else {
                s.removeFirst()
            }
        } while s.count > c.count - 1
        return false
    }
  
        func toDate (format: String) -> Date? {
            return DateFormatter(format: format).date(from: self)
        }
        
        func toDateString (inputFormat: String, outputFormat:String) -> String? {
            if let date = toDate(format: inputFormat) {
                return DateFormatter(format: outputFormat).string(from: date)
            }
            return nil
        }
    

      
}
