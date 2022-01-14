//
//  CommunityNetwork.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/13.
//

import UIKit

final class CommunityNetworkManager {
    static func fetchGatheringPosts(page: Int, completion: @escaping([Gathering]) -> Void) {
        var urlComponents = URLComponents(string: "\(SERVER_URL)/community/read_community?")
        let paramQuery1 = URLQueryItem(name: "code", value: "0")
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
                  let gatherings = try? JSONDecoder().decode([Gathering].self, from: data) else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            print("DEBUG: gatherings index ->", gatherings.map { $0.index })
            
            switch response.statusCode {
            case (200...299):
                print("DEBUG: Network succeded")
                completion(gatherings)
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
    
    func postCommunity(code: Int, title: String, contents: String, images: [UIImage]?, completion: @escaping(Bool) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = dateFormatter.string(from: Date())
        
        var urlComponents = URLComponents(string: "\(SERVER_URL)/community/write_community?")
        let paramQuery1 = URLQueryItem(name: "code", value: "\(code)")
        let paramQuery2 = URLQueryItem(name: "title", value: title)
        let paramQuery3 = URLQueryItem(name: "contents", value: contents)
        let paramQuery4 = URLQueryItem(name: "time", value: time)
        urlComponents?.queryItems?.append(paramQuery1)
        urlComponents?.queryItems?.append(paramQuery2)
        urlComponents?.queryItems?.append(paramQuery3)
        urlComponents?.queryItems?.append(paramQuery4)

        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let images = images {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let httpBody = NSMutableData() // let var //
            for image in images {
                guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
                httpBody.append(convertFileData(fileData: imageData, using: boundary))
            }
            httpBody.appendString("--\(boundary)--")
            let data = httpBody as Data
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
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data as Data
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
          self.append(data)
        }
    }
}

