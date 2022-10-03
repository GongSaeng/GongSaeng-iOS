//
//  URLRequest.swift
//  GongSaeng
//
//  Created by Yujin Cha on 2022/10/04.
//

import Foundation

extension URLRequest {
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
}
