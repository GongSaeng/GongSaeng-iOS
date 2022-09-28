//
//  CommunityNetworkManager.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/13.
//

import UIKit

final class CommunityNetworkManager {
    static func fetchCommunitys(page: Int, communityType: CommunityType, completion: @escaping([Community]) -> Void) {
        var urlComponents = URLComponents(string: "\(SERVER_URL)/community/read_community?")
        let paramQuery1 = URLQueryItem(name: "code", value: "\(communityType.rawValue)")
        urlComponents?.queryItems?.append(paramQuery1)
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
            
            var communitys: [Community] = []
            if let decodedData = try? JSONDecoder().decode([Community].self, from: data) {
                communitys = decodedData
            } else if let decodedData = try? JSONDecoder().decode([Community2].self, from: data) {
                communitys = decodedData.map({ community2 in
                    Community(index: community2.index,
                              title: community2.title,
                              contents: community2.contents,
                              writerId: community2.writerId,
                              writerNickname: community2.writerNickname,
                              uploadedTime: community2.uploadedTime,
                              numberOfComments: community2.numberOfComments)
                })
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
        print("DEBUG: index -> \(index)")
        var urlComponents = URLComponents(string: "\(SERVER_URL)/community/find_post_by_index?")
        let paramQuery = URLQueryItem(name: "post_index", value: "\(index)")
        urlComponents?.queryItems?.append(paramQuery)
        guard let url = urlComponents?.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let posts = try? JSONDecoder().decode([Post].self, from: data),
                  let post = posts.first else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let time = dateFormatter.string(from: Date())
        
        guard let url = URLComponents(string: "\(SERVER_URL)/community/write_community")?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let images = images, let thumbnailImage = images.first {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var data = Data()
            
            let boundaryPrefix = "--\(boundary)\r\n"
            let boundarySuffix = "--\(boundary)--\r\n"
            ["code": code, "title": title, "contents": contents, "time": time].forEach { (key, value) in
                data.append(boundaryPrefix.data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                data.append("\(value)\r\n".data(using: .utf8)!)
            }
            
            for image in images {
                guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }

                let fileName = "\(UUID().uuidString).jpg"
                let fieldName = "image"
                let mimeType = "image/jpeg"
                data.append(boundaryPrefix.data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                data.append(imageData)
                data.append("\r\n".data(using: .utf8)!)
            }

            data.append(boundarySuffix.data(using: .utf8)!)
            
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
             
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil,
                      let response = response as? HTTPURLResponse,
                      let data = data,
                      let returnValue = String(data: data, encoding: .utf8)  else {
                          print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                          return
                      }

                switch response.statusCode {
                case (200...299):
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
    }
    
    static func fetchMyPosts(myPostType: MyPostType, completion: @escaping([MyPost]) -> Void) {
        let scheme = (myPostType == .post) ? "mypost" : "mycomment"
        let urlComponents = URLComponents(string: "\(SERVER_URL)/profile/\(scheme)")
        guard let url = urlComponents?.url else { return }
     
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
        var urlComponents = URLComponents(string: "\(SERVER_URL)/comment/read_comment?")
        let paramQuery1 = URLQueryItem(name: "parent_num", value: "\(index)")
        let paramQuery2 = URLQueryItem(name: "page", value: "\(page)")
        urlComponents?.queryItems?.append(paramQuery1)
        urlComponents?.queryItems?.append(paramQuery2)
        guard let url = urlComponents?.url else { return }
     
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let comments = try? JSONDecoder().decode([Comment].self, from: data) else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
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
    
    static func postComment(index: Int, contents: String, completion: @escaping(Int?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = dateFormatter.string(from: Date())
        
        var urlComponents = URLComponents(string: "\(SERVER_URL)/comment/write_comment?")
        
        let paramQuery1 = URLQueryItem(name: "parent_num", value: "\(index)")
        let paramQuery2 = URLQueryItem(name: "contents", value: contents)
        let paramQuery3 = URLQueryItem(name: "time", value: time)
        urlComponents?.queryItems?.append(paramQuery1)
        urlComponents?.queryItems?.append(paramQuery2)
        urlComponents?.queryItems?.append(paramQuery3)
        
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Int] else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
    
            switch response.statusCode {
            case (200...299):
                print("DEBUG: Updated number of comments -> \(jsonData["count"]!)")
                completion(jsonData["count"])
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
        var urlComponents = URLComponents(string: "\(SERVER_URL)/community/\(communityStr)")
        
        let paramQuery = URLQueryItem(name: "idx", value: "\(index)")
        urlComponents?.queryItems?.append(paramQuery)
        
        guard let url = urlComponents?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
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

private extension CommunityNetworkManager {
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
        var data = Data()
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        data.append(fileData)
        data.append("\r\n".data(using: .utf8)!)
        return data
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
          self.append(data)
        }
    }
}

