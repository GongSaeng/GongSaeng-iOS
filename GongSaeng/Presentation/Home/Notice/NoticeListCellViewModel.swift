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
        var time = notice.time
        var date = ""
        for i in 0...8 {
            if i == 6 {
                date.append("/")
            } else if i < 4 {
                time.removeFirst()
            } else {
                let char = time.removeFirst()
                date.append(char)
            }
        }
        // 시간 포맷 수정!!
        return date
    }
    
    init(notice: Notice) {
        self.notice = notice
    }
}
