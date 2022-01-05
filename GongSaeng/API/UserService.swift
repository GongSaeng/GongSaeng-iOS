//
//  UserService.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/28.
//

import Foundation

struct UserService {
    static func fetchCurrentUser(completion: @escaping(User?) -> Void) {
        print("DEBUG: Call fetchCurrentUser function.. ")
        guard let url = URL(string: "\(SERVER_URL)/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                      print("ERROR: fetchCurrentUser URLSession data task \(error?.localizedDescription ?? "")")
                      completion(nil)
                      return
                  }
            
            guard let userArr = try? JSONDecoder().decode([User].self, from: data) else {
                completion(nil)
                return
            }
            
            let user = !userArr.isEmpty ? userArr[0] : nil
            
            switch response.statusCode {
            case (200...299):
                completion(user)
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
