//
//  EditProfileResultModel.swift
//  GongSaeng
//
//  Created by Yujin Cha on 2022/10/12.
//

struct EditProfileResultData: Decodable {
    var data: EditProfileResult
}

struct EditProfileResult: Decodable {
    var profileImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case profileImageURL = "profile_image_url"
    }
}
