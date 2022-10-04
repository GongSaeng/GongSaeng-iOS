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

final class ThunderNetworkManager {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchThunders(page: Int, by order: SortingOrder, region: String) -> Single<Result<[Thunder], NetworkError>> {
        print("DEBUG: Called fetchThunders().. ")
        
        let regionData = region.split(separator: "/").map { String($0) }
        let metapolis = regionData[0]
        let region = regionData[1]
//        let order = (order == .registeringOrder) ? "meet" : "??"
        
        var urlComponents = URLComponents(string: "\(SERVER_URL)/thunder/list/\(page)?")
        urlComponents?.queryItems = [
            URLQueryItem(name: "order", value: "meet"),
            URLQueryItem(name: "region", value: region),
            URLQueryItem(name: "metapolis", value: metapolis),
        ]
        guard let url = urlComponents?.url else { return .just(.failure(.invalidURL)) }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        return session.rx.data(request: request as URLRequest)
            .map { data -> Result<[Thunder], NetworkError> in
                do {
                    let thunders = try JSONDecoder().decode([Thunder].self, from: data)
                    return .success(thunders)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { _ in
                    .just(.failure(.networkError))
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
    
    func postThunder(meetingTime: String, place: String, placeURL: String, address: String, totalNum: String, title: String, contents: String, images: [UIImage], completion: @escaping(Bool) -> Void) {
        let regionData = address.split(separator: " ").map { String($0) }
        let metapolis = regionData[0]
        let region = regionData[1]
        
        var urlComponents = URLComponents(string: "\(SERVER_URL)/thunder?")
        urlComponents?.queryItems = [
            URLQueryItem(name: "metapolis", value: metapolis),
            URLQueryItem(name: "title", value: title),
            URLQueryItem(name: "contents", value: contents),
            URLQueryItem(name: "meet_time", value: meetingTime),
            URLQueryItem(name: "location", value: place),
            URLQueryItem(name: "detail_location", value: address),
            URLQueryItem(name: "total_num", value: totalNum),
            URLQueryItem(name: "location_url", value: placeURL),
            URLQueryItem(name: "region", value: region)
        ]

        guard let url = urlComponents?.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let thumbnailImage = images.first!
        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let httpBody = NSMutableData() // let var //
        guard let imageData = thumbnailImage.downSize(newWidth: 100)
                .jpegData(compressionQuality: 0.5) else { return }
        httpBody.append(convertFileData(fileData: imageData, using: boundary))
        for image in images {
            guard let imageData = image.jpegData(compressionQuality: 1) else { return }
            httpBody.append(convertFileData(fileData: imageData, using: boundary))
        }
        httpBody.appendString("--\(boundary)--")
        let data = httpBody as Data
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
    
    static func fetchThunderDetail(index: Int, completion: @escaping(ThunderDetail) -> Void) {
        // 네트워크 로직
        let urlComponents = URLComponents(string: "\(SERVER_URL)/thunder/\(index)")
        guard let url = urlComponents?.url else { return }
     
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let thunderDetail = try? JSONDecoder().decode(ThunderDetail.self, from: data) else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            
            switch response.statusCode {
            case (200...299):
                print("DEBUG: Network succeded")
                DispatchQueue.main.async {
                    completion(thunderDetail)
                }
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
    
    static func fetchComments(index: Int, completion: @escaping([Comment]) -> Void) {
        // 네트워크 로직
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) { // 임시 더미데이터
            DispatchQueue.main.async {
                completion(exampleComments)
            }
        }
    }
}

private extension ThunderNetworkManager {
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        return fieldString
    }
    
    func convertFileData(fileData: Data, using boundary: String) -> Data {
        let fileName = "\(UUID().uuidString).jpg"
        let fieldName = "image"
        let mimeType = "image/jpeg"
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data as Data
    }
}
