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
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        guard let request = getMultipartFormDataPATCHRequest(url: "\(SERVER_URL)/profile",
                                                             boundary: boundary) else { return }
        
        let params: [String: Any] = ["nickname": nickname,
                                     "job": job,
                                     "profile": introduce]
        let data = getMultipartFormData(boundary: boundary,
                                        params: params,
                                        images: profileImage == nil ? [] : [profileImage!])
        
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
                print("DEBUG: UserService.editProfile() response succeded..", returnValue)
                let isSucceded = (returnValue == "false") ? false : true
                let imageUrl = (isSucceded && (returnValue != "true")) ? returnValue : nil
                completion(isSucceded, imageUrl)
            default:
                handleError(response: response)
            }
        }
        dataTask.resume()
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
    
    static func editPassword(oldPassword: String, newPassword: String, completion: @escaping(Bool) -> Void) {
        guard let request = getPATCHRequest(url: "\(SERVER_URL)/profile/password",
                                            data: ["oldPassword": oldPassword,
                                                   "newPassword": newPassword] as Dictionary<String, Any>) else { return }
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
            case 403:
                completion(false)
            default:
                handleError(response: response)
            }
        }
        dataTask.resume()
    }
}
