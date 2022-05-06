//
//  NetworkError.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/05/04.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidJSON
    case networkError
    
    var message: String {
        switch self {
        case .invalidURL, .invalidJSON:
            return "데이터를 불러올 수 없습니다."
        case .networkError:
            return "네트워크 상태를 확인해주세요."
        }
    }
}
