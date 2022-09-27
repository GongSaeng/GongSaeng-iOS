//
//  GongSaengTalkListCellViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/11/29.
//

import UIKit

struct GongSaengTalkListCellViewModel {
    var title: String
    var category: String
    
    init(talk: GongSaengTalk) {
        self.title = talk.title
        self.category = talk.category
    }
}
