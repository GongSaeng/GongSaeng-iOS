//
//  Public.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/13.
//

import UIKit

// 바로 사용에서 사용할 아이템을 선택하고 사용을 하게 되면 현재시간에서 추가한 시간만큼 더하고 끝나는 시간을 기록하는 것이 좋을 듯 하다.
struct Public: Decodable, Equatable {
    var imgTitle: String // 무조건
    var title: String // 무조건
    var maxTime: Int // 각 아이템은 최대 사용 가능 시간이 무조건 존재
    var isDone: Bool // Using, 무조건
    var usingUser: String? // 사용중이지 않으면 유저가 없을 수 있음
    var startTime: String?
    var finalTime: String? // 사용중이지 않으면 없어도 됌
    var remainingTime: Int? { // 없어도 되고 그때그때 계산하면 됨
        guard let endTime = self.finalTime else { return 0 }
        return Date.remainingTime(start: Date.currentTime, end: endTime)
    }
    
    mutating func update(imgTitle: String, title: String, maxTime: Int, isDone: Bool, usingUser: String?, finalTime: String?) {
        self.imgTitle = imgTitle
        self.title = title
        self.maxTime = maxTime
        self.isDone = isDone // true: using
        self.usingUser = usingUser // id
        self.finalTime = finalTime
    }
}

class PublicViewModel {
    enum Section: Int, CaseIterable {
        case using
        case toUse
        
        var title: String {
            switch self {
            case .using: return "사용중" // 내가 사용중 상태
            default: return "사용하기" // 그 외 상태
            }
        }
    }
    
    var publics: [Public] = [
        // isDone = true, usingUser: 값존재, finalTime: 값존재
        // isDone = false, 다 있거나 말거나
        // 세탁기 1은 사용중인데 나는 아니다.
        Public(imgTitle: "qwer", title: "세탁기1", maxTime: 100, isDone: true, usingUser: "1234", finalTime: "2021-7-16 18:00:00"),
        // 세탁기 2는 사용하지 않고 있다.
        Public(imgTitle: "qwer", title: "세탁기2", maxTime: 90, isDone: false, usingUser: nil, finalTime: nil),
        // 세탁기 3은 사용중이고 나다.
        Public(imgTitle: "qwer", title: "세탁기3", maxTime: 80, isDone: true, usingUser: "jyy0223", finalTime: "2021-7-17 12:30:30"),
        // 세탁기 4는 사용하지 않고 있다.
        Public(imgTitle: "qwer", title: "세탁기4", maxTime: 70, isDone: false, usingUser: "jyy0223", finalTime: nil)
    ]
    
    var numOfSection: Int {
        return Section.allCases.count
    }
    
    var numOfItems: Int {
        return publics.count
    }

    func indexOfImgTitle(at index: Int) -> String {
        return publics[index].imgTitle
    }
    
    func indexOfPublic(at index: Int) -> Public {
        return publics[index]
    }
    
    func usingPublics(loginUser: User?) -> [Public] {
        return publics.filter { $0.isDone == true && $0.usingUser == loginUser?.id}
    }
    
    func availablePublics(loginUser: User?) -> [Public] {
        return publics.filter { !($0.isDone == true && $0.usingUser == loginUser?.id) }
    }
    
    var availablePublics: [Public] {
        return publics.filter { $0.isDone == false }
    }
}

class ReservationViewModel {
    enum Section: Int, CaseIterable {
        case using
        case detail
        case toUse
        
        var title: String {
            switch self {
            case .using:
                return "사용중"
            case .detail:
                return "예약 내역"
            case .toUse:
                return "예약하기"
            }
        }
    }
    
    var publics: [Public] = [
        Public(imgTitle: "qwer", title: "멘토링실", maxTime: 100, isDone: true, usingUser: "jyy0223", startTime: "2021-7-16 16:00:00", finalTime: "2021-7-16 18:00:00"),
        Public(imgTitle: "qwer", title: "멘토링실", maxTime: 90, isDone: false, usingUser: nil, startTime: nil, finalTime: nil),
        Public(imgTitle: "qwer", title: "멘토링실", maxTime: 80, isDone: true, usingUser: "jyy0223", startTime: "2021-7-17 18:00:00", finalTime: "2021-7-17 20:00:00"),
        Public(imgTitle: "qwer", title: "멘토링실", maxTime: 70, isDone: false, usingUser: "jyy0223", startTime: nil, finalTime: nil)
        ]
    
    var numOfSection: Int {
        return Section.allCases.count
    }
    
    var numOfItems: Int {
        return publics.count
    }

    func indexOfImgTitle(at index: Int) -> String {
        return publics[index].imgTitle
    }
    
    func indexOfPublic(at index: Int) -> Public {
        return publics[index]
    }
    
    // 사용중
    func usingPublics(loginUser: User?) -> [Public] {
        return publics.filter { $0.isDone == true && $0.usingUser == loginUser?.id && "2021-7-16 17:00:00" >= ($0.startTime ?? "0000-0-00 00:00:00") }
        // 현재시간이 시작시간 이상이면 사용중 상태, 현재시간은 임시로 표현
    }
    
    // 예약 내역
    func toUsePublics(loginUser: User?) -> [Public] {
        return publics.filter { $0.isDone == true && $0.usingUser == loginUser?.id && "2021-7-16 17:00:00" < ($0.startTime ?? "0000-0-00 00:00:00") }
    }
    
    // 예약하기
    func availablePublics(loginUser: User?) -> [Public] {
        return publics.filter { !($0.isDone == true && $0.usingUser == loginUser?.id) }
    }
    
    var availablePublics: [Public] {
        return publics.filter { $0.isDone == false }
    }
}
