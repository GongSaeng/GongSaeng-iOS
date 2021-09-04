//
//  Date.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/13.
//

import Foundation


extension Date {
    private static var dateFormatExtension: DateFormatter {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ko_kr")
        dateFormat.timeZone = TimeZone(abbreviation: "KST")
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormat
    }
    
    public var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    public var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    public var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    // 현재 시간을 string 로 반환
    static var currentTime: String {
        let dateFormat = self.dateFormatExtension
        return dateFormat.string(from: Date())
    }
    
    // 분을 입력받아 현재시간에 더해 string로 반환한다.
    static func minuteFromNow(minute: TimeInterval) -> String {
        let dateFormat = self.dateFormatExtension
        let time: Date = Self(timeIntervalSinceNow: minute)
        let stringTime: String = dateFormat.string(from: time)
        return stringTime
    }
    
    // 시작과 끝 시간을 입력으로 받아 차이를 분으로 반환한다.
    static func remainingTime(start: String, end: String) -> Int {
        let dateFormat = self.dateFormatExtension
        let startDate = dateFormat.date(from: start)!
        let endDate = dateFormat.date(from: end)!
        
        let interval = endDate.timeIntervalSince(startDate)
        let minutes = Int(interval / 60) // 분단위로 나타낼 것이다.
        return minutes
    }
}
