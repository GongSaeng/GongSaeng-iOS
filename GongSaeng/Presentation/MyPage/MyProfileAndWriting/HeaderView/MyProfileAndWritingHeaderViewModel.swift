//
//  MyProfileAndWritingHeaderViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/05/06.
//

import UIKit

enum WrittenButtonType {
    case post, comment
}

struct MyProfileAndWritingHeaderViewModel {
    var selectedButtonType: WrittenButtonType = .post
    
    private var isPostButtonSelected: Bool { selectedButtonType == .post }
    var isPostButtonEnabled: Bool { !isPostButtonSelected }
    var postButtonTextColor: UIColor {
        isPostButtonSelected ? .black : .black.withAlphaComponent(0.2)
    }
    var postButtonBackgroundColor: UIColor {
        isPostButtonSelected ? .white : .black.withAlphaComponent(0.05)
    }
    
    private var isCommentButtonSelected: Bool { selectedButtonType == .comment }
    var isCommentButtonEnabled: Bool { !isCommentButtonSelected }
    var commentButtonTextColor: UIColor {
        isCommentButtonSelected ? .black : .black.withAlphaComponent(0.2)
    }
    var commentButtonBackgroundColor: UIColor {
        isCommentButtonSelected ? .white : .black.withAlphaComponent(0.05)
    }
    
    var profileImageURL: URL?
    var nickname: String
    var job: String
    var email: String
    var introduce: String
    
    init(user: User) {
        self.profileImageURL = user.profileImageUrl
        self.nickname = user.nickname
        self.job = user.job ?? "-"
        self.email = user.email ?? "-"
        self.introduce = user.introduce ?? "-"
    }
}
