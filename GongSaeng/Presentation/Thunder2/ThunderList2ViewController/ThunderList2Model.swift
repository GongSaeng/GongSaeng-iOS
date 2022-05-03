//
//  ThunderList2Model.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/14.
//

import Foundation
import RxSwift

final class ThunderList2Model {
    func fetchThunders(page: Int, by order: SortingOrder, region: String?) -> Single<Result<[Thunder], Error>> {
        return ThunderNetworkManager.fetchThunders(page: page, by: order, region: region)
    }
    
    func getThundersValue(_ result: Result<[Thunder], Error>) -> [Thunder]? {
        guard case .success(let value) = result else { return nil }
        return value
    }
    
    func getThundersError(_ result: Result<[Thunder], Error>) -> String? {
        guard case .failure(let error) = result else { return nil }
        return error.localizedDescription
    }
    
    func getThunderListCellData(_ value: [Thunder]) -> [ThunderListCellViewModel] {
        return value.map { ThunderListCellViewModel(thunder: $0) }
    }
    
    func fetchMyThunders() -> Single<Result<[MyThunder], Error>> {
        return ThunderNetworkManager.fetchMyThunders()
    }
    
    func getMyThundersValue(_ result: Result<[MyThunder], Error>) -> [MyThunder]? {
        guard case .success(let value) = result else { return nil }
        return value
    }
    
    func getMyThundersError(_ result: Result<[Thunder], Error>) -> String? {
        guard case .failure(let error) = result else { return nil }
        return error.localizedDescription
    }
}
