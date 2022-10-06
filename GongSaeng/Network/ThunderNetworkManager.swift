//
//  ThunderNetworkManager.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/28.
//

import UIKit
import RxSwift

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

    static func fetchMyThunders() -> Single<Result<[ThunderDetailInfo], NetworkError>> {
        print("DEBUG: Called fetchMyThunders().. ")
        let urlComponents = URLComponents(string: "\(SERVER_URL)/profile/thunder")
        guard let url = urlComponents?.url else { return .just(.failure(.invalidURL)) }
     
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return URLSession.shared.rx.data(request: request as URLRequest)
            .map { data -> Result<[ThunderDetailInfo], NetworkError> in
                print("내 번개",String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\\n", with: "\n"))
                do {
                    let thunders = try JSONDecoder().decode(MyThunderData.self, from: data)
                    print("내 번개", thunders.data)
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
