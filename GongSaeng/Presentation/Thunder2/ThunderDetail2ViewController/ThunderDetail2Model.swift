//
//  ThunderDetail2Model.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/30.
//

//import Foundation
//import RxSwift
//
//final class ThunderDetail2Model {
//    func fetchThunderDetail(index: Int) -> Single<Result<ThunderDetail, Error>> {
//        return ThunderNetworkManager.fetchThunderDetail(index: index)
//    }
//    
//    func getThunderDetailValue(_ result: Result<ThunderDetail, Error>) -> ThunderDetail? {
//        guard case .success(let value) = result else { return nil }
//        return value
//    }
//    
//    func getThunderDetailError(_ result: Result<ThunderDetail, Error>) -> String? {
//        guard case .failure(let error) = result else { return nil }
//        return error.localizedDescription
//    }
//}
