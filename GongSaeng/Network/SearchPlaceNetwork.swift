//
//  SearchPlaceNetwork.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/07.
//

import Foundation

struct SearchPlaceNetwork: NetworkManager {
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let path = "/v2/local/search/keyword.json"
    
    static func searchPlace(of page: Int, query: String, completion: @escaping(Place) -> Void) {
        var components = URLComponents()
        components.scheme = SearchPlaceNetwork.scheme
        components.host = SearchPlaceNetwork.host
        components.path = SearchPlaceNetwork.path
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK c53b14f5143c8010a2775513501100c0", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let place = try? JSONDecoder().decode(Place.self, from: data) else {
                      print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            switch response.statusCode {
            case (200...299):
                completion(place)
            default:
                handleError(response: response)
            }
        }

        dataTask.resume()
    }
}
