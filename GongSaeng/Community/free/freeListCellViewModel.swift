//
//  freeListViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/11/29.
//

import UIKit

struct freeListCellViewModel {
    private let free: free
    
    var title: String? {
        return free.title
    }
    
    var contents: String? {
        return free.contents
    }
    /*
    var category: String? {
        return free.category
    }*/
    
    var time: String? {
        let time = free.time
        // 시간 포맷 수정!!
        return time
    }
    
    var writer: String? {
        return free.writer
    }
    
    var index: Int? {
        return free.index
    }
    
    init(free: free) {
        self.free = free
    }
}
