//
//  Mate.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import Foundation

struct Mate: Codable, Equatable {
    var id: Int
    var nickName: String
    var job: String
    var email: String
    var introduce: String
    
    mutating func update(id: Int, nickName: String, job: String, email: String, introduce: String) {
        self.id = id
        self.nickName = nickName
        self.job = job
        self.email = email
        self.introduce = introduce
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id && lhs.nickName == rhs.nickName
    }
}

class MateViewModel {
    static var lastId: Int = 0
    
    var mates: [Mate] = [
        Mate(id: 0, nickName: "남자0호", job: "변호사", email: "@naver.com", introduce: "동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세"),
        Mate(id: 1, nickName: "남자1호", job: "판사", email: "@nate.com", introduce: "안녕하신가"),
        Mate(id: 2, nickName: "남자2호", job: "검사", email: "@gmail.com", introduce: "301호 새로들어옴 동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라만세 ㅁ;니ㅏㅇㄹㅁ;니ㅏㅇㄹㅁ;ㅣ낭ㅁ;ㅣ나ㅓㅁ;ㅣ나ㅓㄹ;미낭;미나ㅓ"),
        Mate(id: 3, nickName: "남자3호", job: "예술사", email: "@facebook.com", introduce: "하나! 우리는 자유민주주의를 수호하며 조국통일의 역군이 된다?"),
        Mate(id: 4, nickName: "남자4호", job: "계발자", email: "@pusan.ac.kr", introduce: "뜨거운 코드를 가르며 너에게 가고있어ㅗ~~"),
        Mate(id: 5, nickName: "남자5호", job: "앱등이", email: "@daum.net", introduce: "나랑 별보러 가지 않을래???? 어디든 좋으니 잠깐 나홀뢔~~~~~"),
        Mate(id: 6, nickName: "남자6호", job: "백수", email: "@한메일", introduce: "막껄리 한좐~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 에!!!!! "),
        Mate(id: 7, nickName: "남자7호", job: "부산대학생", email: "@넥슨", introduce: "박효신 박효신 그림자를 따라서~~ 땅거미진 어둠속을 그대와 걷고 있네요~~~~~"),
        Mate(id: 8, nickName: "남자8호", job: "공무원", email: "@또뭐있냐", introduce: "칼칼나마 알아철니 주납수은 수은 백금")
    ]
    
    var numOfMates: Int {
        return mates.count
    }
    
    func indexOfMate(at index: Int) -> Mate {
        return mates[index]
    }
    
    func indexOfId(at index: Int) -> Int {
        return mates[index].id
    }
    
    func indexOfNickName(at index: Int) -> String {
        return mates[index].nickName
    }
    
    func createMate(nickName: String, job: String, email: String, introduce: String) -> Mate {
        return Mate(id: MateViewModel.lastId, nickName: nickName, job: job, email: email, introduce: introduce)
    }
    
    func addMate(_ mate: Mate) {
        guard let _ = mates.firstIndex(of: mate) else {
            mates.append(mate)
            MateViewModel.lastId = mates.count
            return
        }
        
    }
    
    func updateMate(_ mate: Mate) {
        guard let index = mates.firstIndex(of: mate) else { return }
        mates[index].update(id: mate.id, nickName: mate.nickName, job: mate.job, email: mate.email, introduce: mate.introduce)
    }
    
    func deleteMate(_ mate: Mate) {
        mates = mates.filter { $0 != mate }
        MateViewModel.lastId = mates.count
    }
}
