//
//  AuthService.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/27.
//

import Foundation

struct AuthService: NetworkManager {
    static func loginUserIn(withID id: String, password: String, completion: ((Bool, Bool, Error?) -> Void)? = nil) {
        var urlComponents = URLComponents(string: "\(SERVER_URL)/login?")
        
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
                  let data = data,
                  let returnValue = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]],
                  let jsonArr = returnValue.first  else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
    
            switch response.statusCode {
            case (200...299):
                guard let completion = completion else { return }
                let isRight: Bool = (jsonArr["login"] == "true") ? true : false
                let isApproved: Bool = (jsonArr["approve"] == "true") ? true : false
                completion(isRight, isApproved, nil)
            default:
                handleError(response: response)
            }
        }
        dataTask.resume()
    }
    
    static func logUserOut(completion: @escaping(Bool) -> Void) {
        print("DEBUG: Call logUserOut function.. ")
        guard let request = getGETRequest(url: "\(SERVER_URL)/logout",
                                          data: [:]) else { return }
        
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
                print("DEBUG: logout \(json)")
                if json == "OK" {
                    print("DEBUG: logout succeded")
                    completion(true)
                }
            default:
                handleError(response: response)
            }
        }
        
        dataTask.resume()
    }
    
    static func registerUser(registeringUser register: Register, completion: ((Bool) -> Void)? = nil) {
        guard let id = register.id, let password = register.password,
              let department = register.university?.name, let name = register.name,
              let dateOfBirth = register.dateOfBirth, let phoneNumber = register.phoneNumber,
              let nickname = register.nickname else { return }
        
        var urlComponents = URLComponents(string: "\(SERVER_URL)/register?")
        
        let paramQuery1 = URLQueryItem(name: "id", value: id)
        let paramQuery2 = URLQueryItem(name: "pass", value: password)
        let paramQuery3 = URLQueryItem(name: "department", value: department)
        let paramQuery4 = URLQueryItem(name: "name", value: name)
        let paramQuery5 = URLQueryItem(name: "birth", value: dateOfBirth)
        let paramQuery6 = URLQueryItem(name: "phone", value: phoneNumber)
        let paramQuery7 = URLQueryItem(name: "nickname", value: nickname)
        
        urlComponents?.queryItems?.append(paramQuery1)
        urlComponents?.queryItems?.append(paramQuery2)
        urlComponents?.queryItems?.append(paramQuery3)
        urlComponents?.queryItems?.append(paramQuery4)
        urlComponents?.queryItems?.append(paramQuery5)
        urlComponents?.queryItems?.append(paramQuery6)
        urlComponents?.queryItems?.append(paramQuery7)
        
        guard let url = urlComponents?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      guard let completion = completion else { return }
                      completion(false)
                      return
                  }
            guard let returnValue = String(data: data, encoding: .utf8) else {
                print("DEBUG: No ReturnValue")
                return
            }
    
            switch response.statusCode {
            case (200...299):
                guard let completion = completion else { return }
                if returnValue == "true" {
                    completion(true)
                } else {
                    completion(false)
                }
            default:
                handleError(response: response)
            }
        }
        dataTask.resume()
    }
    
    static func checkIdDuplicate(idToCheck id: String, completion: @escaping(Bool) -> Void) {
        guard let request = getGETRequest(url: "\(SERVER_URL)/register/idCheck?",
                                          data: ["id": id]) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
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
                completion(returnValue.contains("true"))
            case 409:
                completion(false)
            default:
                handleError(response: response)
            }
        }
        
        dataTask.resume()
    }
    
    static func checkNicknameDuplicate(nickNameToCheck nickName: String, completion: @escaping(Bool) -> Void) {
        guard let request = getGETRequest(url: "\(SERVER_URL)/register/nicknameCheck?",
                                          data: ["nickname": nickName]) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
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
                completion(returnValue.contains("true"))
            case 409:
                completion(false)
            default:
                handleError(response: response)
            }
        }
        
        dataTask.resume()
    }
}
