//
//  NoticeListViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/11/29.
//

import UIKit

struct NoticeListCellViewModel {
    var title: String
    var category: String
    
    init(notice: Notice) {
        self.title = notice.title
        self.category = notice.category
    }
}
