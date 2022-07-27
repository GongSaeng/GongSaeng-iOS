//
//  MateCellViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/12/24.
//

import UIKit

struct MateCellViewModel {
//    private let mate: Mate
    
    var nickname: String?
    
    var job: String?
    
    var email: String?
    
    var introduce: String?
    
    var profileImageURL: URL?
    
    init(mate: Mate) {
//        self.mate = mate
        self.nickname = mate.nickname
        self.job = mate.job
        self.email = mate.email
        self.introduce = mate.introduce
        self.profileImageURL = mate.profileImageFilename
            .flatMap { URL(string: SERVER_IMAGE_URL + $0) }
    }
}
