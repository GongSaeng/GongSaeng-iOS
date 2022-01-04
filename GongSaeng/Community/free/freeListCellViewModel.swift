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

        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let tempDate = dateFormatter1.date(from: time) ?? Date()
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MM/dd"
        let dateStr = dateFormatter2.string(from: tempDate)
        
//        let dateFormatter3 = DateFormatter()
//        dateFormatter3.dateFormat = "HH:mm"
        return dateStr
    }
    
    var writer: String? {
        return free.writer
    }
    
    init(free: free) {
        self.free = free
    }
}
