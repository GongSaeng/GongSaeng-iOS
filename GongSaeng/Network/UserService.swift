//
//  UserService.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/28.
//

import UIKit

struct UserService: NetworkManager {
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
            
            guard let userArr = try? JSONDecoder().decode([User].self, from: data), let user = userArr.first else {
                completion(nil)
                return
            }
            
            switch response.statusCode {
            case (200...299):
                completion(user)
            default:
                handleError(response: response)
            }
        }
        
        dataTask.resume()
    }
    
    static func editProfile(nickname: String, job: String, introduce: String, profileImage: UIImage?, completion: @escaping(Bool, String?) -> Void) {
        var urlComponents = URLComponents(string: "\(SERVER_URL)/profile/edit?")

        let paramQuery1 = URLQueryItem(name: "nickname", value: nickname)
        let paramQuery2 = URLQueryItem(name: "job", value: job)
        let paramQuery3 = URLQueryItem(name: "profile", value: introduce)
        urlComponents?.queryItems?.append(paramQuery1)
        urlComponents?.queryItems?.append(paramQuery2)
        urlComponents?.queryItems?.append(paramQuery3)

        guard let url = urlComponents?.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let profileImage = profileImage {
            let fileName = "\(UUID().uuidString).jpg"
            let boundary = UUID().uuidString
            
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let data: Data = {//
                var data = Data()
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                data.append(profileImage.jpegData(compressionQuality: 0.5)!)
                data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
                return data
            }()
            
            let dataTask = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
                print("얍", String(data: data!, encoding: .utf8))
                guard error == nil,
                      let response = response as? HTTPURLResponse,
                      let data = data,
                      let returnValue = String(data: data, encoding: .utf8)  else {
                          print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                          return
                      }

                switch response.statusCode {
                case (200...299):
                    print("DEBUG: UserService.editProfile() response succeded..", returnValue)
                    let isSucceded = (returnValue == "false") ? false : true
                    let imageUrl = (isSucceded && (returnValue != "true")) ? returnValue : nil
                    completion(isSucceded, imageUrl)
                default:
                    handleError(response: response)
                }
            }
            dataTask.resume()
            
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                print("얍",String(data: data!, encoding: .utf8))
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
                    completion(isSucceded, nil)
                default:
                    handleError(response: response)
                }
            }
            dataTask.resume()
        }
    }
    
    static func editAccount(name: String, email: String, phoneNumber: String, completion: @escaping(Bool) -> Void) {
        guard let request = getPATCHRequest(url: "\(SERVER_URL)/profile/account",
                                            data: ["name": name,
                                                   "mail": email,
                                                   "phone": phoneNumber] as Dictionary<String, Any>) else { return }
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
    
            switch response.statusCode {
            case (200...299):
                let isSucceded: Bool = String(data: data, encoding: .utf8)!.contains("true")
                completion(isSucceded)
            default:
                handleError(response: response)
            }
        }
        dataTask.resume()
    }
    
    static func editPassword(password: String, completion: @escaping(Bool) -> Void) {
        
        var urlComponents = URLComponents(string: "\(SERVER_URL)/profile/pass_change?")
        
        let paramQuery = URLQueryItem(name: "pass", value: password)
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
                let isSucceded: Bool = String(data: data, encoding: .utf8) == "true"
                completion(isSucceded)
            default:
                handleError(response: response)
            }
        }
        dataTask.resume()
    }
}
