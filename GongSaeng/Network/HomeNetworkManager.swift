//
//  HomeNetworkManager.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/11/29.
//

import UIKit

extension HomeNetworkManager {
    static let sampleData = [
        GongSaengTalk(dictionary: ["title": "내 절친 소개하기", "category": "가볍"]),
        GongSaengTalk(dictionary: ["title": "내가 생각하는 내 MBTI의 특징", "category": "가볍"]),
        GongSaengTalk(dictionary: ["title": "어린시절 엄마가 절대 사주지 않았지만, 사주길 바랬던 물건", "category": "가볍"]),
        GongSaengTalk(dictionary: ["title": "최근에 먹었던 음식 중 꼭 다시 먹고 싶은 것이 있다면?", "category": "가볍"]),
        GongSaengTalk(dictionary: ["title": "2시간 뒤 내가 죽는다는 걸 알았다면, 지금 당장 무얼 할까?", "category": "가볍"]),
        GongSaengTalk(dictionary: ["title": "내일 학교나 직장에 안가도 되지만 꼭 밖에 나가야 한다면 무얼 할까?", "category": "가볍"]),
        GongSaengTalk(dictionary: ["title": "로또를 샀는데 우연히 5000만원 당첨되었다. 어떻게 쓸지 3개만 말해보라.", "category": "가볍"]),
        GongSaengTalk(dictionary: ["title": "다시 태어나면 어느 나라에서 태어나고싶나?", "category": "가볍"]),
        GongSaengTalk(dictionary: ["title": "그 사람이 아니라는 걸 알지만, 왜 그 당시에는 그 사람에게 휩쓸릴 수 밖에 없었는가?", "category": "진지"]),
        GongSaengTalk(dictionary: ["title": "내가 당해본 가스라이팅", "category": "진지"]),
        GongSaengTalk(dictionary: ["title": "초등학교 때, 내가 좋아했던 그 아이", "category": "진지"]),
        GongSaengTalk(dictionary: ["title": "나의 절절한 사랑 이야기", "category": "진지"]),
        GongSaengTalk(dictionary: ["title": "내가 해본 일탈 중 가장 후회하지 않는 것", "category": "진지"]),
        GongSaengTalk(dictionary: ["title": "내가 나의 부모였다면 이건 절대 하지 않았을 것 같다 생각하는것?", "category": "진지"]),
        GongSaengTalk(dictionary: ["title": "내가 인생에서 가장 힘들었던 시절로 돌아가면 누구에게 어떤 도움을 청할까?", "category": "진지"]),
        GongSaengTalk(dictionary: ["title": "내가 살면서 만난 친구 중 가장 존경하는 친구와 그 이유는?", "category": "진지"]),
        GongSaengTalk(dictionary: ["title": "나의 꼰대 선배 이야기", "category": "재미"]),
        GongSaengTalk(dictionary: ["title": "최악의 팀플 메이트는?", "category": "재미"]),
        GongSaengTalk(dictionary: ["title": "만나본 직장 상사/동기 중 가장 최악은?", "category": "재미"]),
        GongSaengTalk(dictionary: ["title": "내가 본 영화나 책 중 주인공이 될 수 있다면?", "category": "재미"]),
        GongSaengTalk(dictionary: ["title": "술먹고 했던 실수 중 가장 심했던 것?", "category": "재미"]),
        GongSaengTalk(dictionary: ["title": "죽기 전에 꼭 다시 먹고싶은 것은?", "category": "재미"]),
        GongSaengTalk(dictionary: ["title": "친구랑 혹은 혼자 해본 가장 미친 짓은?", "category": "재미"]),
        GongSaengTalk(dictionary: ["title": "죽기 전에 꼭 해보고 싶은 일탈은?", "category": "재미"])
    ]
}

struct HomeNetworkManager {
    static func fetchGongSaengTalk(completion: @escaping([GongSaengTalk]) -> Void) {
        guard let url = URL(string: "\(SERVER_URL)/notify/read_notify") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let talks = try? JSONDecoder().decode([GongSaengTalk].self, from: data) else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
            switch response.statusCode {
            case (200...299):
                // completion(talks)
                completion(HomeNetworkManager.sampleData)
            case (400...499):
                print("""
                    ERROR: Client ERROR \(response.statusCode)
                    Response: \(response)
                """)
            case (500...599):
                print("""
                    ERROR: Server ERROR \(response.statusCode)
                    Response: \(response)
                """)
            default:
                print("""
                    ERROR: \(response.statusCode)
                    Response: \(response)
                """)
            }
        }
        
        dataTask.resume()
    }
    
    static func fetchMate(department: String, completion: @escaping([Mate]) -> Void) {
        guard let url = URL(string: "\(SERVER_URL)/mate") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let mates = try? JSONDecoder().decode([Mate].self, from: data) else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            switch response.statusCode {
            case (200...299):
                completion(mates)
            case (400...499):
                print("""
                    ERROR: Client ERROR \(response.statusCode)
                    Response: \(response)
                """)
            case (500...599):
                print("""
                    ERROR: Server ERROR \(response.statusCode)
                    Response: \(response)
                """)
            default:
                print("""
                    ERROR: \(response.statusCode)
                    Response: \(response)
                """)
            }
        }
        
        dataTask.resume()
    }
}
