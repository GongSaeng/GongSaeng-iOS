//
//  CommunityNetworkManager.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/13.
//

import UIKit

final class CommunityNetworkManager {
    static func fetchCommunitys(page: Int, communityType: CommunityType, completion: @escaping([Community]) -> Void) {
        guard let request = URLRequest.getGETRequest(url: "\(SERVER_URL)/community/read_community?",
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
    
    static func fetchPost(index: Int, completion: @escaping(Post) -> Void) {
        guard let request = URLRequest.getGETRequest(url: "\(SERVER_URL)/community/find_post_by_index?",
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
    
    func postCommunity(code: Int, title: String, contents: String, images: [UIImage]?, category: String? = nil, price: String? = nil, completion: @escaping(Bool) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        
        guard let request = URLRequest.getMultipartFormDataRequest(url: "\(SERVER_URL)/community/write_community",
                                                                   boundary: boundary) else { return }
        
        var params: [String: Any] = ["code": code, "title": title, "contents": contents, "time": Date.getNowDateTime()]
        params["category"] = category
        params["price"] = price
        let data = URLRequest.getMultipartFormData(boundary: boundary,
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
    
    static func fetchMyPosts(myPostType: MyPostType, completion: @escaping([MyPost]) -> Void) {
        let scheme = (myPostType == .post) ? "mypost" : "mycomment"
        guard let request = URLRequest.getGETRequest(url: "\(SERVER_URL)/profile/\(scheme)",
                                                     data: [:]) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let myPosts = try? JSONDecoder().decode([MyPost].self, from: data) else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            
            switch response.statusCode {
            case (200...299):
                print("DEBUG: Network succeded")
                completion(myPosts)
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
    
    static func fetchComments(page: Int, index: Int, completion: @escaping([Comment]) -> Void) {
        guard let request = URLRequest.getGETRequest(url: "\(SERVER_URL)/comment/read_comment?",
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
    
    static func postComment(index: Int, contents: String, completion: @escaping(Bool?) -> Void) {
        guard let request = URLRequest.getPOSTRequest(url: "\(SERVER_URL)/comment/write_comment",
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
    
    static func completeValidStatus(index: Int, communityType: CommunityType , completion: @escaping(Bool) -> Void) {
        let communityStr = communityType == .gathering ? "together_complete?" : "market_complete?"
        guard let request = URLRequest.getPOSTRequest(url: "\(SERVER_URL)/community/\(communityStr)",
                                                      data: ["idx": index] as Dictionary<String, Any>) else { return }
        
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
                let isSucceded = String(data: data, encoding: .utf8) == "true" ? true : false
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
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
          self.append(data)
        }
    }
}

