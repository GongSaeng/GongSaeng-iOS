//
//  freeCommentCellViewModel.swift
//  GongSaeng
//
//  Created by 유경민 on 2021/12/30.
//

import UIKit

struct freeCommentCellViewModel {
    private let free_comment: free_comment
    
    var comment: String? {
        return free_comment.comment
    }
    
    var writer: String? {
        return free_comment.writer
    }
    /*
    var category: String? {
        return free.category
    }*/
    
    var time: String? {
        let time = free_comment.time
        // 시간 포맷 수정!!
        return time
    }
    
    
    init(free_comment: free_comment) {
        //print("aaaaaaaaaa")
        self.free_comment = free_comment
    }
}
