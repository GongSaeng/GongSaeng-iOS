//
//  MateCellViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/24.
//

import UIKit

struct MateCellViewModel {
    private let mate: Mate
    
    var nickname: String? {
        return mate.nickname
    }
    
    var job: String? {
        return mate.job
    }
    
    var email: String? {
        return mate.email
    }
    
    var introduce: String? {
        return mate.introduce
    }
    
    init(mate: Mate) {
        self.mate = mate
    }
}
