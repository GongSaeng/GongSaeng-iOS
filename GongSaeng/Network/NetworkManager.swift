//
//  NetworkManager.swift
//  GongSaeng
//
//  Created by Yujin Cha on 2022/10/04.
//

import UIKit

protocol NetworkManager {
    static func handleError(response: HTTPURLResponse)
}

extension NetworkManager {
    static func handleError(response: HTTPURLResponse) {
        switch response.statusCode {
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
}

extension NetworkManager {
    static func getGETRequest(url: String, data: Dictionary<String, Any>) -> URLRequest? {
        var urlComponents = URLComponents(string: url)
        data.forEach { (key: String, value: Any) in
            urlComponents?.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
        }
        guard let url = urlComponents?.url else { return nil }
     
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    static func getPOSTRequest(url: String, data: Dictionary<String, Any>) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
        request.httpBody = jsonData
        return request
    }
    
    static func getPATCHRequest(url: String, data: Dictionary<String, Any>) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
        request.httpBody = jsonData
        return request
    }
    
    static func getDELETERequest(url: String, data: Dictionary<String, Any>) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
        request.httpBody = jsonData
        return request
    }
}

extension NetworkManager {
    static func getMultipartFormDataRequest(url: String, boundary: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    static func getMultipartFormDataPATCHRequest(url: String, boundary: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    static func getMultipartFormData(boundary: String, params: Dictionary<String, Any>, images: [UIImage]) -> Data {
        var data = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        let boundarySuffix = "--\(boundary)--\r\n"
        
        data.append(convertParams(params, boundaryPrefix))
        data.append(convertImagesData(images, boundaryPrefix))
        data.append(boundarySuffix.data(using: .utf8)!)
        
        return data
    }
    
    static func convertParams(_ params: Dictionary<String, Any>, _ boundaryPrefix: String) -> Data {
        var data = Data()
        params.forEach { (key, value) in
            data.append(boundaryPrefix.data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(value)\r\n".data(using: .utf8)!)
        }
        return data
    }
    
    static func convertImagesData(_ images: [UIImage], _ boundaryPrefix: String) -> Data {
        var data = Data()
        for image in images {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return data }
            
            let fileName = "\(UUID().uuidString).jpg"
            let fieldName = "image"
            let mimeType = "image/jpeg"
            data.append(boundaryPrefix.data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
            data.append("\r\n".data(using: .utf8)!)
        }
        return data
    }
}
