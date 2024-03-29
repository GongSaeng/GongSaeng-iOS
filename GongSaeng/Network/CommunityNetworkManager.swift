//
//  CommunityNetworkManager.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/13.
//

import UIKit

final class CommunityNetworkManager: NetworkManager {
    static func fetchCommunitys(page: Int, communityType: CommunityType, completion: @escaping([Community]) -> Void) {
        guard let request = getGETRequest(url: "\(SERVER_URL)/community/read_community?",
                                          data: ["code": communityType.rawValue]) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
            
            guard let communitys = try? JSONDecoder().decode([Community].self, from: data) else {
                print("ERROR: Community 변환 실패:", String(data: data, encoding: .utf8) ?? "")
                return
            }
            
            print("DEBUG: communitys index ->", communitys.map { $0.index })
            
            switch response.statusCode {
            case (200...299):
                print("DEBUG: Network succeded")
                completion(communitys)
            default:
                handleError(response: response)
            }
        }
        
        dataTask.resume()
    }
    
    static func fetchPost(index: Int, completion: @escaping(Post) -> Void) {
        guard let request = getGETRequest(url: "\(SERVER_URL)/community/find_post_by_index?",
                                          data: ["post_index": index]) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
            
            guard let post = try? JSONDecoder().decode([Post].self, from: data).first else {
                print("Error: Decoding post ->", String(data: data, encoding: .utf8) ?? "")
                return
            }
            
            switch response.statusCode {
            case (200...299):
                print("DEBUG: Network succeded")
                
                completion(post)
            default:
                handleError(response: response)
            }
        }
        
        dataTask.resume()
    }
    
    static func postCommunity(code: Int, title: String, contents: String, images: [UIImage]?, category: String? = nil, price: String? = nil, completion: @escaping(Bool) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        
        guard let request = getMultipartFormDataRequest(url: "\(SERVER_URL)/community/write_community",
                                                        boundary: boundary) else { return }
        
        var params: [String: Any] = ["code": code, "title": title, "contents": contents, "time": Date.currentTime]
        params["category"] = category
        params["price"] = price
        let data = getMultipartFormData(boundary: boundary,
                                        params: params,
                                        images: images == nil ? [] : images!)
        
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
                let isSucceded = (returnValue == "true") ? true : false
                completion(isSucceded)
            default:
                handleError(response: response)
            }
        }
        dataTask.resume()
    }
    
    static func fetchMyPosts(myPostType: MyPostType, completion: @escaping([MyWritten]) -> Void) {
        let scheme = (myPostType == .post) ? "community" : "comment"
        guard let request = getGETRequest(url: "\(SERVER_URL)/profile/\(scheme)",
                                          data: [:]) else { return }
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            
            var myWritten: [MyWritten] = []
            if myPostType == .post {
                guard let myPosts = try? JSONDecoder().decode(MyPostData.self, from: data) else {
                    print("ERROR: MyPost decoding error", String(data: data, encoding: .utf8))
                    return
                }
                myWritten = myPosts.data
            } else {
                guard let myComments = try? JSONDecoder().decode(MyCommentData.self, from: data) else {
                    print("ERROR: MyComment decoding error", String(data: data, encoding: .utf8))
                    return
                }
                myWritten = myComments.data
            }
            
            switch response.statusCode {
            case (200...299):
                print("DEBUG: Network succeded")
                completion(myWritten)
            default:
                handleError(response: response)
            }
        }
        
        dataTask.resume()
    }
    
    static func fetchComments(page: Int, index: Int, completion: @escaping([Comment]) -> Void) {
        guard let request = getGETRequest(url: "\(SERVER_URL)/comment/read_comment?",
                                          data: ["parent_num": index, "page": page]) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
            
            guard let comments = try? JSONDecoder().decode([Comment].self, from: data) else {
                print("ERROR: comments decoding failed ->", String(data: data, encoding: .utf8) ?? "")
                return
            }
            
            print("DEBUG: comments index ->", comments)
            
            switch response.statusCode {
            case (200...299):
                print("DEBUG: Network succeded")
                completion(comments)
            default:
                handleError(response: response)
            }
        }
        
        dataTask.resume()
    }
    
    static func postComment(index: Int, contents: String, completion: @escaping(Bool?) -> Void) {
        guard let request = getPOSTRequest(url: "\(SERVER_URL)/comment/write_comment",
                                           data: ["parent_num": index,
                                                  "contents": contents] as Dictionary<String, Any>) else { return }
        
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
    
    static func completeValidStatus(index: Int, completion: @escaping(Bool) -> Void) {
        guard let request = getPATCHRequest(url: "\(SERVER_URL)/community/status",
                                           data: ["idx": index, "status": 1] as Dictionary<String, Any>) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            switch response.statusCode {
            case (200...299):
                print("DEBUG: postComment() data -> \(String(data: data, encoding: .utf8)!)")
                let isSucceded = String(data: data, encoding: .utf8)!.contains("true") ? true : false
                completion(isSucceded)
            default:
                handleError(response: response)
            }
        }
        dataTask.resume()
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
          self.append(data)
        }
    }
}

