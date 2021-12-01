//
//  NoticeListViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/11/29.
//

import UIKit

struct NoticeListCellViewModel {
    private let notice: Notice
    
    var title: String? {
        return notice.title
    }
    
    var contents: String? {
        return notice.contents
    }
    
    var category: String? {
        return notice.category
    }
    
    var time: String? {
        let time = notice.time
        // 시간 포맷 수정!!
        return time
    }
    
    init(notice: Notice) {
        self.notice = notice
    }
}
