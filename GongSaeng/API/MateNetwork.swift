//
//  MateNetwork.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/24.
//

import UIKit

struct MateNetwork {
    static func fetchMate(department: String, completion: @escaping([Mate]) -> Void) {
        
        var urlComponents = URLComponents(string: "http://18.118.131.221:7777/user?")
        
        let paramQuery = URLQueryItem(name: "department", value: department)
        urlComponents?.queryItems?.append(paramQuery)
        
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            print("DEBUG: data -> \(data!)")
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
