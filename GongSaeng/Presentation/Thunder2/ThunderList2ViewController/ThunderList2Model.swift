//
//  ThunderList2Model.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/14.
//

import Foundation
import RxSwift

final class ThunderList2Model {
    
    func fetchThunders(region: String?, by order: SortingOrder, page: Int) -> Single<Result<[Thunder], Error>> {
        ThunderNetworkManager.fetchThunders(region: region, by: order, page: page)
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
}
