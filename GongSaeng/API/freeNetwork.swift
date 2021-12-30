//
//  freeNetwork.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/11/29.
//

import UIKit

struct freeNetwork {
    
    static func freeCommentWrite(num parent_num : String, contentsText contents: String, completion: ((Bool) -> Void)? = nil) {
        var urlComponents = URLComponents(string: "http://18.118.131.221:2222/comment?")
        
        let paramQuery1 = URLQueryItem(name: "parent_num", value: "3" )
        let paramQuery2 = URLQueryItem(name: "contents", value: contents)
        
        urlComponents?.queryItems?.append(paramQuery1)
        urlComponents?.queryItems?.append(paramQuery2)
        
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
            guard let returnValue = String(data: data, encoding: .utf8) else {
                print("DEBUG: No ReturnValue")
                return
            }
    
            switch response.statusCode {
            case (200...299):
                guard let completion = completion else { return }
                if returnValue == "ok" {
                    completion(true)
                } else {
                    completion(false)
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
    
    static func freeWrite(titleText title : String, contentsText contents: String, completion: ((Bool) -> Void)? = nil) {
        var urlComponents = URLComponents(string: "http://18.118.131.221:2222/community?")
        
        let paramQuery1 = URLQueryItem(name: "title", value: title )
        let paramQuery2 = URLQueryItem(name: "contents", value: contents)
        let paramQuery3 = URLQueryItem(name: "code", value: "0")
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
                  let data = data else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            guard let returnValue = String(data: data, encoding: .utf8) else {
                print("DEBUG: No ReturnValue")
                return
            }
    
            switch response.statusCode {
            case (200...299):
                guard let completion = completion else { return }
                if returnValue == "ok" {
                    completion(true)
                } else {
                    completion(false)
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
    
    
    static func fetchfree(completion: @escaping([free]) -> Void) {
        guard let url = URL(string: "http://18.118.131.221:2222/community?community_num=0") else { return }
        //guard let url = URL(string: "http://18.118.131.221:2222/comment?parent_num=3") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let frees = try? JSONDecoder().decode([free].self, from: data) else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            switch response.statusCode {
            case (200...299):
                completion(frees.reversed()) // 임시로 역순
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
    
    static func fetch_freecomment(completion: @escaping([free_comment]) -> Void) {
        guard let url = URL(string: "http://18.118.131.221:2222/comment?parent_num=3") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let free_comments = try? JSONDecoder().decode([free_comment].self, from: data) else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            switch response.statusCode {
            case (200...299):
                print("""
                    complete!!!!!!!!!!!
                """)
                completion(free_comments)
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
