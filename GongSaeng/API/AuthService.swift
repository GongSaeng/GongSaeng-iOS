//
//  AuthService.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/27.
//

import Foundation

struct AuthService {
    static func loginUserIn(withID id: String, password: String, completion: @escaping(Bool) -> Void) {
        var urlComponents = URLComponents(string: "http://18.118.131.221:7777/login?")
        
        let paramQuery1 = URLQueryItem(name: "id", value: id)
        let paramQuery2 = URLQueryItem(name: "pass", value: password)
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
                if returnValue == "true" {
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
    
    static func logUserOut(completion: @escaping(Bool) -> Void) {
        print("DEBUG: Call logUserOut function.. ")
        guard let url = URL(string: "http://18.118.131.221:7777/logout") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                      print("ERROR: fetchCurrentUser URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            
            guard let json = String(data: data, encoding: .utf8) else {
                print("ERROR: data parsing failed..")
                return
            }
            
            switch response.statusCode {
            case (200...299):
                if json == "OK" {
                    print("DEBUG: logout succeded")
                    completion(true)
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
}
