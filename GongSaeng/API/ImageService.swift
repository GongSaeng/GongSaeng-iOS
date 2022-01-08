//
//  ImageService.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/06.
//

import Foundation
import UIKit

struct ImageService {
    static func postImage(image: UIImage, completion: @escaping(String) -> Void) {
        let fileName = "\(UUID().uuidString).jpg"
        guard let url = URL(string: "\(SERVER_URL)/image/post_image") else { return }
        
        let boundary = UUID().uuidString
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let data: Data = {
            var data = Data()
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(image.jpegData(compressionQuality: 0.75)!)
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            return data
        }()
        
        URLSession.shared.uploadTask(with: urlRequest, from: data) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let fileName = String(data: data, encoding: .utf8)  else {
                      print("ERROR: postImage URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            
            switch response.statusCode {
            case (200...299):
                completion(fileName)
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
        }.resume()
    }
    
    static func getImage(fileName: String, completion: @escaping(UIImage) -> Void) {
        var urlComponents = URLComponents(string: "\(SERVER_URL)/image/get_image?")
        let paramQuery = URLQueryItem(name: "image_url", value: fileName)
        urlComponents?.queryItems?.append(paramQuery)
        
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let image = UIImage(data: data) else {
                      print("ERROR: getImage URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            switch response.statusCode {
            case (200...299):
                completion(image)
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
