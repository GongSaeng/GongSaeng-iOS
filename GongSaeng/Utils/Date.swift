//
//  Date.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/13.
//

import Foundation

extension String {
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: self)
      }
    
    func convertEnToKo() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        if let date = dateFormatter.date(from: self + "+9") {
            return Date.getFormattedString(from: date)
        }
        return self
    }
    
    func toAnotherDateString(form: String) -> String? {
        let beforeDateFormatter = DateFormatter()
        let afterDateFormatter = DateFormatter()
        beforeDateFormatter.locale = Locale(identifier: "ko_KR")
        beforeDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        afterDateFormatter.locale = Locale(identifier: "ko_KR")
        afterDateFormatter.dateFormat = form
        return beforeDateFormatter.date(from: self)
            .flatMap { afterDateFormatter.string(from: $0) }
    }
    
    func toRemainingDays() -> String {
        let krDateFormatter = DateFormatter()
        krDateFormatter.dateFormat = "yyyy-MM-dd 00:00:00"
        krDateFormatter.locale = Locale(identifier: "ko_KR")
        
        let stdOClockDateFormatter = DateFormatter()
        stdOClockDateFormatter.dateFormat = "yyyy-MM-dd 00:00:00"
        stdOClockDateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let stdDateFormatter = DateFormatter()
        stdDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        stdDateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let dateStr = krDateFormatter.string(from: Date())
        let date = stdDateFormatter.date(from: dateStr)!

        let daysInterval = stdDateFormatter.date(from: self)
            .flatMap { stdOClockDateFormatter.string(from:$0) }
            .flatMap { stdDateFormatter.date(from: $0) }
            .flatMap { Calendar.current.dateComponents([.day], from: date, to: $0).day }
            .flatMap { $0 } ?? 0
        return daysInterval == 0 ? "Today" : "D-\(daysInterval)"
    }
}

extension Date {
    static func getFormattedString(from date: Date) -> String {
        return dateFormatExtension.string(from: date)
    }
    
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
