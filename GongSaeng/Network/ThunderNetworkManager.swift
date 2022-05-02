//
//  ThunderNetworkManager.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/28.
//

import Foundation
import RxSwift

let exampleThunders: [Thunder] = [
    Thunder(index: 0, validStatus: 1, title: "간단하게 맥주마셔요~", thumbnailImageName: TEST_IMAGE1_URL, meetingTime: "2022-03-19 17:00:00", placeName: "온천천", remainingNum: 3, totalNum: 4),
    Thunder(index: 0, validStatus: 1, title: "같이 코노가요!", thumbnailImageName: TEST_IMAGE2_URL, meetingTime: "2022-03-20 17:30:00", placeName: "동전노래연습장", remainingNum: 2, totalNum: 4),
    Thunder(index: 0, validStatus: 1, title: "보드게임 할 사람~~", thumbnailImageName: TEST_IMAGE3_URL, meetingTime: "2022-03-21 18:00:00", placeName: "두기보드게임", remainingNum: 4, totalNum: 6),
    Thunder(index: 0, validStatus: 1, title: "간단하게 맥주마셔요~", thumbnailImageName: TEST_IMAGE1_URL, meetingTime: "2022-03-22 17:00:00", placeName: "온천천", remainingNum: 3, totalNum: 4),
    Thunder(index: 0, validStatus: 1, title: "같이 코노가요!", thumbnailImageName: TEST_IMAGE2_URL, meetingTime: "2022-03-23 17:30:00", placeName: "동전노래연습장", remainingNum: 2, totalNum: 4),
    Thunder(index: 0, validStatus: 1, title: "보드게임 할 사람~~", thumbnailImageName: TEST_IMAGE3_URL, meetingTime: "2022-03-24 18:00:00", placeName: "두기보드게임", remainingNum: 4, totalNum: 6),
    Thunder(index: 0, validStatus: 0, title: "간단하게 맥주마셔요~", thumbnailImageName: TEST_IMAGE1_URL, meetingTime: "2022-02-25 17:00:00", placeName: "온천천", remainingNum: 0, totalNum: 4),
    Thunder(index: 0, validStatus: 0, title: "같이 코노가요!", thumbnailImageName: TEST_IMAGE2_URL, meetingTime: "2022-02-24 17:30:00", placeName: "동전노래연습장", remainingNum: 0, totalNum: 4),
    Thunder(index: 0, validStatus: 0, title: "보드게임 할 사람~~", thumbnailImageName: TEST_IMAGE3_URL, meetingTime: "2022-02-25 18:00:00", placeName: "두기보드게임", remainingNum: 0, totalNum: 6),
    Thunder(index: 0, validStatus: 0, title: "간단하게 맥주마셔요~", thumbnailImageName: TEST_IMAGE1_URL, meetingTime: "2022-02-23 17:00:00", placeName: "온천천", remainingNum: 0, totalNum: 4),
    Thunder(index: 0, validStatus: 0, title: "같이 코노가요!", thumbnailImageName: TEST_IMAGE2_URL, meetingTime: "2022-02-24 17:30:00", placeName: "동전노래연습장", remainingNum: 0, totalNum: 4),
    Thunder(index: 0, validStatus: 0, title: "보드게임 할 사람~~", thumbnailImageName: TEST_IMAGE3_URL, meetingTime: "2022-02-25 18:00:00", placeName: "두기보드게임", remainingNum: 0, totalNum: 6)
]

let exampleThunderDetail = ThunderDetail(
    postingImagesFilename: [TEST_IMAGE2_URL, TEST_IMAGE3_URL, TEST_IMAGE1_URL],
    title: "같이 코노가요 가나다라마바사아자차카타파하 글자길이 테스트 2줄은 어떻게 보이나 3줄은 어떻게 보이려나",
    writerImageFilename: TEST_IMAGE4_URL,
    writerId: "jdc0407",
    writerNickname: "네잎클로버",
    uploadedTime: "2022-03-19 13:35:31",
    meetingTime: "2022-03-22 19:00:00",
    placeName: "레드노래연습장 부산대점",
    address: "부산 금정구 금강로 271",
    placeURL: "http://place.map.kakao.com/12421917",
    totalNum: 6,
    contents: "저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~",
    participantsProfile: [
        Profile(profileImageURL: TEST_IMAGE4_URL,
                id: "jdc0407",
                nickname: "네잎클로버",
                job: "전기공학과",
                email: "nupic7@pusan.ac.kr",
                introduce: "반갑습니다~ iOS 앱개발자 입니다~~ 잘 부탁드려요!\n공생공생 개발중입니다~~"),
        Profile(profileImageURL: TEST_IMAGE5_URL,
                id: "jdc1234",
                nickname: "코로나확진자",
                job: "신소재공학과",
                email: "oluye7@pusan.ac.kr",
                introduce: "신소재공학과 새내기에요~! "),
        Profile(profileImageURL: TEST_IMAGE6_URL,
                id: "jdc5678",
                nickname: "자가격리자",
                job: "철학과",
                email: "diresty@pusan.ac.kr",
                introduce: "16 화석이에요~~")
    ],
    status: 1,
    numberOfComments: 15)

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
                    id: "jdc0407",
                    nickname: "네잎클로버",
                    job: "전기공학과",
                    email: "nupic7@pusan.ac.kr",
                    introduce: "반갑습니다~ iOS 앱개발자 입니다~~ 잘 부탁드려요!\n공생공생 개발중입니다~~"),
            Profile(profileImageURL: TEST_IMAGE5_URL,
                    id: "jdc1234",
                    nickname: "코로나확진자",
                    job: "신소재공학과",
                    email: "oluye7@pusan.ac.kr",
                    introduce: "신소재공학과 새내기에요~! "),
            Profile(profileImageURL: TEST_IMAGE6_URL,
                    id: "jdc5678",
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
                    id: "jdc0407",
                    nickname: "네잎클로버",
                    job: "전기공학과",
                    email: "nupic7@pusan.ac.kr",
                    introduce: "반갑습니다~ iOS 앱개발자 입니다~~ 잘 부탁드려요!\n공생공생 개발중입니다~~"),
            Profile(profileImageURL: TEST_IMAGE6_URL,
                    id: "jdc5678",
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
        title: "간단하게 맥주마셔요~",
        meetingTime: "2022-03-23 18:00:00",
        placeName: "온천천",
        address: "부산 금정구 부곡동",
        placeURL: "http://place.map.kakao.com/25728616",
        totalNum: 4,
        contents: "온천천에서 산책하면서 가볍게 맥주하실 분들 찾고있습니다!",
        participantsProfile: [
            Profile(profileImageURL: TEST_IMAGE4_URL,
                    id: "jdc0407",
                    nickname: "네잎클로버",
                    job: "전기공학과",
                    email: "nupic7@pusan.ac.kr",
                    introduce: "반갑습니다~ iOS 앱개발자 입니다~~ 잘 부탁드려요!\n공생공생 개발중입니다~~")
        ],
        status: 1,
        numberOfComments: 10)
]

final class ThunderNetworkManager1 {
    static func fetchThunderDetail(index: Int, completion: @escaping(ThunderDetail) -> Void) {
        // 네트워크 로직
        completion(exampleThunderDetail) // 임시 더미데이터
    }
}

final class ThunderNetworkManager {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    static func fetchThunders(page: Int, by order: SortingOrder, region: String?) -> Single<Result<[Thunder], Error>> {
        print("DEBUG: Called fetchThunders().. ")
        return Single<Result<[Thunder], Error>>.create { single -> Disposable in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                DispatchQueue.main.async {
                    single(.success(.success(exampleThunders)))
                }
            }
            return Disposables.create()
        }
        
    }

    static func fetchMyThunder(id: String) -> Single<Result<[MyThunder], Error>> {
        return .just(.success(exampleMyThunders))
//        print("DEBUG: Called fetchMyThunder()..")
//        return Single<Result<
    }

    static func fetchThunderDetail(index: Int) -> Single<Result<ThunderDetail, Error>> {
        print("DEBUG: Called fetchThunderDetail()..")
        return Single<Result<ThunderDetail, Error>>.create { single -> Disposable in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                DispatchQueue.main.async {
                    single(.success(.success(exampleThunderDetail)))
                }
            }
            return Disposables.create()
        }
    }
    
//    func postThunder(nickname: String, meetingTime: String, place: String, placeURL: String, address: String, totalNum: Int, title: String, contents: String, region: String, completion: @escaping(Bool) -> Void) {
//
//        let regionData = region.split(separator: "/").map { String($0) }
//        let region = regionData[0]
//        let metapolis = regionData[1]
//
//        var urlComponents = URLComponents(string: "\(SERVER_URL)/community/write_community?")
//        urlComponents?.queryItems = [
//            URLQueryItem(name: "writer_nickname", value: nickname),
//            URLQueryItem(name: "metapolis", value: metapolis),
//            URLQueryItem(name: "title", value: title),
//            URLQueryItem(name: "contents", value: contents),
//            URLQueryItem(name: "contents_image", value: ""), // ???
//            URLQueryItem(name: "meet_time", value: meetingTime),
//            URLQueryItem(name: "location", value: place),
//            URLQueryItem(name: "detail_location", value: address),
//            URLQueryItem(name: "total_num", value: "\(totalNum)"),
//            URLQueryItem(name: "writer_image", value: ""), // ???
//            URLQueryItem(name: "location_url", value: placeURL),
//            URLQueryItem(name: "region", value: region)
//        ]
//
//        guard let url = urlComponents?.url else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        if let images = images, let thumbnailImage = images.first {
//            let boundary = "Boundary-\(UUID().uuidString)"
//            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//            let httpBody = NSMutableData() // let var //
//            guard let imageData = thumbnailImage.downSize(newWidth: 100)
//                    .jpegData(compressionQuality: 0.5) else { return }
//            httpBody.append(convertFileData(fileData: imageData, using: boundary))
//            for image in images {
//                guard let imageData = image.jpegData(compressionQuality: 1) else { return }
//                httpBody.append(convertFileData(fileData: imageData, using: boundary))
//            }
//            httpBody.appendString("--\(boundary)--")
//            let data = httpBody as Data
//            let dataTask = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
//                guard error == nil,
//                      let response = response as? HTTPURLResponse,
//                      let data = data,
//                      let returnValue = String(data: data, encoding: .utf8)  else {
//                          print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
//                          return
//                      }
//                switch response.statusCode {
//                case (200...299):
//                    print("DEBUG: postCommunity response is succeded..", returnValue)
//                    let isSucceded = (returnValue == "true") ? true : false
//                    completion(isSucceded)
//                case (400...499):
//                    print("""
//                        ERROR: Client ERROR \(response.statusCode)
//                        Response: \(response)
//                    """)
//                case (500...599):
//                    print("""
//                        ERROR: Server ERROR \(response.statusCode)
//                        Response: \(response)
//                    """)
//                default:
//                    print("""
//                        ERROR: \(response.statusCode)
//                        Response: \(response)
//                    """)
//                }
//            }
//            dataTask.resume()
//
//        } else {
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard error == nil,
//                      let response = response as? HTTPURLResponse,
//                      let data = data,
//                      let returnValue = String(data: data, encoding: .utf8)  else {
//                          print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
//                          return
//                      }
//
//                switch response.statusCode {
//                case (200...299):
//                    let isSucceded = (returnValue == "true") ? true : false
//                    completion(isSucceded)
//                case (400...499):
//                    print("""
//                        ERROR: Client ERROR \(response.statusCode)
//                        Response: \(response)
//                    """)
//                case (500...599):
//                    print("""
//                        ERROR: Server ERROR \(response.statusCode)
//                        Response: \(response)
//                    """)
//                default:
//                    print("""
//                        ERROR: \(response.statusCode)
//                        Response: \(response)
//                    """)
//                }
//            }
//            dataTask.resume()
//        }
}
