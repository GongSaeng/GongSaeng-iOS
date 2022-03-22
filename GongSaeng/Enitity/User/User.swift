//
//  User.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/18.
//
import UIKit

struct User: Codable {
    var id, name, dateOfBirth, phoneNumber, department, nickname: String
    var job, email, introduce, profileImageFilename: String?
    var profileImageUrl: URL? {
        profileImageFilename.flatMap { URL(string: SERVER_IMAGE_URL + $0) }
    }

    enum CodingKeys: String, CodingKey {
        case id, name, department, job
        case email = "mail"
        case dateOfBirth = "birth"
        case phoneNumber = "phone"
        case nickname = "nickname"
        case introduce = "profile"
        case profileImageFilename = "profile_image_url"
    }
    
    mutating func updateUser(id: String? = nil, name: String? = nil, dateOfBirh: String? = nil, phoneNumber: String? = nil, department: String? = nil, nickName: String? = nil, job: String? = nil, email: String? = nil, introduce: String? = nil, profileImageFilename: String? = nil) {
        if let id = id { self.id = id }
        if let name = name { self.name = name }
        if let dateOfBirh = dateOfBirh { self.dateOfBirth = dateOfBirh }
        if let phoneNumber = phoneNumber { self.phoneNumber = phoneNumber }
        if let department = department { self.department = department }
        if let nickName = nickName { self.nickname = nickName }
        if let job = job { self.job = job }
        if let email = email { self.email = email }
        if let introduce = introduce { self.introduce = introduce }
        if let profileImageFilename = profileImageFilename { self.profileImageFilename = profileImageFilename }
    }
}
