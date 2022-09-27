//
//  HomeNetworkManager.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/11/29.
//

import UIKit

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
                completion(talks)
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
