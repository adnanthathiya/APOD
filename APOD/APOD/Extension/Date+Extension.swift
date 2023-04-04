//
//  Date+Extension.swift
//  APOD
//
//  Created by Adnan Thathiya on 04/04/23.
//

import Foundation

extension Date {
    static func today() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: Date())
    }
}
