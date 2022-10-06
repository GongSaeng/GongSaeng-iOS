//
//  ThunderNetworkManager.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/28.
//

import UIKit
import RxSwift

let exampleComments: [Comment] = [
    Comment(contents: "안녕하세요~ 저 코로나 확진인데 같이 놀아도 될까요??",
            writerImageFilename: TEST_IMAGE5_URL,
            writerNickname: "코로나확진자",
            uploadedTime: "2022-03-02 14:20:00"),
    Comment(contents: "저두 같이 놀고 싶어서 참여했어요 ~~",
            writerImageFilename: TEST_IMAGE6_URL,
            writerNickname: "자가격리자",
            uploadedTime: "2022-03-02 14:25:00"),
    Comment(contents: "안녕하세요~ 저 코로나 확진인데 같이 놀아도 될까요??",
            writerImageFilename: TEST_IMAGE5_URL,
            writerNickname: "코로나확진자",
            uploadedTime: "2022-03-02 14:20:00"),
    Comment(contents: "저두 같이 놀고 싶어서 참여했어요 ~~",
            writerImageFilename: TEST_IMAGE6_URL,
            writerNickname: "자가격리자",
            uploadedTime: "2022-03-02 14:25:00"),
    Comment(contents: "안녕하세요~ 저 코로나 확진인데 같이 놀아도 될까요??",
            writerImageFilename: TEST_IMAGE5_URL,
            writerNickname: "코로나확진자",
            uploadedTime: "2022-03-02 14:20:00"),
    Comment(contents: "저두 같이 놀고 싶어서 참여했어요 ~~",
            writerImageFilename: TEST_IMAGE6_URL,
            writerNickname: "자가격리자",
            uploadedTime: "2022-03-02 14:25:00"),
    Comment(contents: "안녕하세요~ 저 코로나 확진인데 같이 놀아도 될까요??",
            writerImageFilename: TEST_IMAGE5_URL,
            writerNickname: "코로나확진자",
            uploadedTime: "2022-03-02 14:20:00"),
    Comment(contents: "저두 같이 놀고 싶어서 참여했어요 ~~",
            writerImageFilename: TEST_IMAGE6_URL,
            writerNickname: "자가격리자",
            uploadedTime: "2022-03-02 14:25:00")
]

let exampleMyThunders: [MyThunder] = [
    MyThunder(
        postIndex: 0,
        postingImageFilename: TEST_IMAGE2_URL,
        title: "같이 코노가요!",
        meetingTime: "2022-03-21 17:00:00",
        placeName: "레드노래연습장 부산대점",
        address: "부산 금정구 금강로 271",
        placeURL: "http://place.map.kakao.com/12421917",
        totalNum: 6,
        contents: "저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다!",
        participantsProfile: [
            Profile(profileImageURL: TEST_IMAGE4_URL,
                    nickname: "네잎클로버",
                    job: "전기공학과",
                    email: "nupic7@pusan.ac.kr",
                    introduce: "반갑습니다~ iOS 앱개발자 입니다~~ 잘 부탁드려요!\n공생공생 개발중입니다~~"),
            Profile(profileImageURL: TEST_IMAGE5_URL,
                    nickname: "코로나확진자",
                    job: "신소재공학과",
                    email: "oluye7@pusan.ac.kr",
                    introduce: "신소재공학과 새내기에요~! "),
            Profile(profileImageURL: TEST_IMAGE6_URL,
                    nickname: "자가격리자",
                    job: "철학과",
                    email: "diresty@pusan.ac.kr",
                    introduce: "16 화석이에요~~")
        ],
        status: 1,
        numberOfComments: 15),
    MyThunder(
        postIndex: 1,
        postingImageFilename: TEST_IMAGE3_URL,
        title: "보드게임 할 사람~~",
        meetingTime: "2022-03-22 17:30:00",
        placeName: "두기 보드게임",
        address: "부산 금정구 금강로 265",
        placeURL: "http://place.map.kakao.com/19934212",
        totalNum: 4,
        contents: "보드게임 같이 하실 분들~ 잘못하지만 좋아해서 실력보단 재미있게 같이하실 분들 찾고 있어요!",
        participantsProfile: [
            Profile(profileImageURL: TEST_IMAGE4_URL,
                    nickname: "네잎클로버",
                    job: "전기공학과",
                    email: "nupic7@pusan.ac.kr",
                    introduce: "반갑습니다~ iOS 앱개발자 입니다~~ 잘 부탁드려요!\n공생공생 개발중입니다~~"),
            Profile(profileImageURL: TEST_IMAGE6_URL,
                    nickname: "자가격리자",
                    job: "철학과",
                    email: "diresty@pusan.ac.kr",
                    introduce: "16 화석이에요~~")
        ],
        status: 1,
        numberOfComments: 30),
    MyThunder(
        postIndex: 2,
        postingImageFilename: TEST_IMAGE1_URL,
        title: "간단하게 맥주마셔요~ 가나다라마바사아자차카타파하",
        meetingTime: "2022-03-23 18:00:00",
        placeName: "온천천",
        address: "부산 금정구 부곡동",
        placeURL: "http://place.map.kakao.com/25728616",
        totalNum: 4,
        contents: "온천천에서 산책하면서 가볍게 맥주하실 분들 찾고있습니다!",
        participantsProfile: [
            Profile(profileImageURL: TEST_IMAGE4_URL,
                    nickname: "네잎클로버",
                    job: "전기공학과",
                    email: "nupic7@pusan.ac.kr",
                    introduce: "반갑습니다~ iOS 앱개발자 입니다~~ 잘 부탁드려요!\n공생공생 개발중입니다~~")
        ],
        status: 1,
        numberOfComments: 10)
]

final class ThunderNetworkManager: NetworkManager {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchThunders(page: Int, by order: SortingOrder, region: String) -> Single<Result<[Thunder], NetworkError>> {
        print("DEBUG: Called fetchThunders().. ")
        
        let regionData = region.split(separator: "/").map { String($0) }
        let metapolis = regionData[0]
        let region = regionData[1]
        let order = (order == .registeringOrder) ? "registering" : "closing"
        
        guard let request = ThunderNetworkManager.getGETRequest(url: "\(SERVER_URL)/thunder?",
                                          data: ["order": order,
                                                 "region": region,
                                                 "metapolis": metapolis]) else {
            return .just(.failure(.invalidURL))
        }
        
        return session.rx.data(request: request as URLRequest)
            .map { data -> Result<[Thunder], NetworkError> in
                print("번개",String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\\n", with: "\n"))
                do {
                    let thunders = try JSONDecoder().decode(ThunderData.self, from: data)
                    print("번개", thunders)
                    return .success(thunders.data)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { error in
                return .just(.failure(.networkError))
            }
            .asSingle()
    }

    static func fetchMyThunders() -> Single<Result<[MyThunder], Error>> {
        print("DEBUG: Called fetchMyThunders().. ")
        return Single<Result<[MyThunder], Error>>.create { single -> Disposable in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                DispatchQueue.main.async {
                    single(.success(.success(exampleMyThunders)))
                }
            }
            return Disposables.create()
        }
    }
    
    static func postThunder(meetingTime: String, place: String, placeURL: String, address: String, totalNum: String, title: String, contents: String, images: [UIImage], completion: @escaping(Bool) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        
        guard let request = getMultipartFormDataRequest(url: "\(SERVER_URL)/community/write_community",
                                                        boundary: boundary) else { return }
        
        
        let regionData = address.split(separator: " ").map { String($0) }
        let metapolis = regionData[0]
        let region = regionData[1]
        var params: [String: Any] = ["metapolis": metapolis,
                                     "title": title,
                                     "contents": contents,
                                     "meet_time": meetingTime,
                                     "location": place,
                                     "detail_location": address,
                                     "total_num": totalNum,
                                     "location_url": placeURL,
                                     "region": region]
        
        let data = getMultipartFormData(boundary: boundary,
                                        params: params,
                                        images: images)
        
        let dataTask = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let returnValue = String(data: data, encoding: .utf8)  else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            switch response.statusCode {
            case (200...299):
                print("DEBUG: postCommunity response is succeded..", returnValue)
                let isSucceded = (returnValue == "200") ? true : false
                completion(isSucceded)
            default:
                handleError(response: response)
            }
        }
        dataTask.resume()
    }
    
    static func fetchThunderDetail(index: Int, completion: @escaping(ThunderDetailInfo) -> Void) {
        // 네트워크 로직
        let urlComponents = URLComponents(string: "\(SERVER_URL)/thunder/\(index)")
        guard let url = urlComponents?.url else { return }
     
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let thunderDetail = try? JSONDecoder().decode(ThunderDetailData.self, from: data) else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            print("번개디테일", thunderDetail.data)
            switch response.statusCode {
            case (200...299):
                print("DEBUG: Network succeded")
                DispatchQueue.main.async {
                    completion(thunderDetail.data)
                }
            default:
                handleError(response: response)
            }
        }
        
        dataTask.resume()
    }
    
    // TODO: Should replace to real
    static func joinThunder(index: Int, completion: @escaping(Bool) -> Void) {
        guard let request = getPOSTRequest(url: "\(SERVER_URL)/thunder/join",
                                           data: ["idx": index] as Dictionary<String, Any>) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            print(String(data: data, encoding: .utf8))
            switch response.statusCode {
            case (200...299):
                print("DEBUG: joinThunder() data -> \(String(data: data, encoding: .utf8)!)")
                let isSucceded = String(data: data, encoding: .utf8) == "true" ? true : false
                completion(isSucceded)
            default:
                handleError(response: response)
            }
        }
        dataTask.resume()
    }
    
    static func fetchComments(page: Int, index: Int, completion: @escaping([Comment]) -> Void) {
        let urlComponents = URLComponents(string: "\(SERVER_URL)/thunder/\(index)/comment")
        guard let url = urlComponents?.url else { return }
     
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
            
            guard let comments = try? JSONDecoder().decode(ThunderComment.self, from: data) else {
                print("ERROR: comments decoding failed ->", String(data: data, encoding: .utf8) ?? "")
                return
            }
            
            print("DEBUG: comments index ->", comments)
            
            switch response.statusCode {
            case (200...299):
                print("DEBUG: Network succeded")
                completion(comments.data)
            default:
                handleError(response: response)
            }
        }
        
        dataTask.resume()
    }
    
    static func postComment(index: Int, contents: String, completion: @escaping(Bool?) -> Void) {
        guard let request = getPOSTRequest(url: "\(SERVER_URL)/thunder/\(index)/comment",
                                           data: ["contents": contents] as Dictionary<String, Any>) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
            
            guard let result = String(data: data, encoding: .utf8) else {
                print("ERROR: post comment result decoding failed ->", String(data: data, encoding: .utf8) ?? "")
                return
            }
    
            switch response.statusCode {
            case (200...299):
                print("DEBUG: Comment updated -> \(result == "true")")
                completion(result == "true")
            default:
                handleError(response: response)
            }
        }
        dataTask.resume()
    }
    
}
