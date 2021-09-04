//
//  User.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/18.
//
import UIKit
import Foundation

struct User: Codable, Equatable {
    var id: String // primary key
    var password: String // Hashing String
    var isDone: Bool = false // 관리자 승인여부

    var name: String
    var dateOfBirth: String
    var phoneNumber: String
    var department: String
    var nickName: String
    
    mutating func update(id: String, password: String, name: String, dateOfBirth: String, phoneNumber: String, department: String, nickName: String) {
        self.id = id
        self.password = password
        
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.phoneNumber = phoneNumber
        self.department = department
        self.nickName = nickName
    }
    
    mutating func loginUserCreate(id: String, password: String) {
        self.id = id
        self.password = password
        
        self.name = ""
        self.dateOfBirth = ""
        self.phoneNumber = ""
        self.department = ""
        self.nickName = ""
    }
    
    mutating func registerMemberUserCreate(name: String, dateOfBirth: String, phoneNumber: String, department: String) {
        self.id = ""
        self.password = ""
        self.nickName = ""
        
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.phoneNumber = phoneNumber
        self.department = department
    }
    
    
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id && lhs.password == rhs.password
    }
}

class UserManager {
    static let shared = UserManager()
    static var lastId: Int = 0
    
    //승인되지 않은 유저 테스트용
    var users: [User] = [User(id: "jyy0223", password: "1234qwer", isDone: true, name: "조영우", dateOfBirth: "19950223", phoneNumber: "01027111995", department: "한국장학재단 부산센터", nickName: "응우")]
    
    // 데이터를 생성하고 추가하는 createUser, addUser의 관계를 잘 파악해야 한다.
    func createUser(id: String, password: String, name: String, dateOfBirth: String, phoneNumber: String, department: String, nickName: String) -> User {
        return User(id: id, password: password, name: name, dateOfBirth: dateOfBirth, phoneNumber: phoneNumber, department: department, nickName: nickName)
    }
    func addUser(_ user: User) {
        users.append(user)
        UserManager.lastId = users.count
        saveUser()
    }
    
    // 회원 탈되 용
    func deleteUser(_ user: User) {
        users = users.filter { $0.id != user.id }
        UserManager.lastId = users.count
        saveUser()
    }
    
    func updateUser(_ user: User) {
        guard let index = users.firstIndex(of: user) else { return }
        users[index].update(id: user.id, password: user.password, name: user.name, dateOfBirth: user.dateOfBirth, phoneNumber: user.phoneNumber, department: user.department, nickName: user.nickName)
        saveUser()
    }
    
    func saveUser() {
        // save user data in Firebase
    }
    
    func retrieveUser() {
        // load user data in Firebase
    }
    
    func idReduplicationCheck(id: String) -> Bool {
        return isReduplicationCheck(property: "id", checkObject: id)
    }
    
    func nickNameReduplicationCheck(nickName: String) -> Bool {
        return isReduplicationCheck(property: "nickName", checkObject: nickName)
    }
    
    func isReduplicationCheck(property: String, checkObject: String) -> Bool {
        var checkedObjects: [User?] = []
        switch property {
        case "id": checkedObjects = self.users.filter {  $0.id == checkObject }
        case "nickName": checkedObjects = self.users.filter { $0.nickName == checkObject }
        default: return false
        }
        return checkedObjects.count != 0
    }
}

class UserViewModel {
    enum Section: Int, CaseIterable {
        case done
        case notDone
        
        var permission: String {
            switch self {
            case .done: return "승인된 인원"
            default: return "승인되지 않은 인원"
            }
        }
    }
    
    private let manager = UserManager.shared
    
    // 밖에서 데이터의 직접 접근을 막자
    private var users: [User] {
        return manager.users
    }
    
    // 승인된 인원 반환
    var doneUser: [User] {
        return users.filter { $0.isDone == true }
    }
    
    // 승인되지 않은 인원 반환
    var notDoneUser: [User] {
        return users.filter { $0.isDone == false }
    }
    
    var usersId: [String]  {
        return manager.users.map { $0.id }
    }
    
    var numOfUsers: Int {
        return self.users.count
    }
    
    // 두 유저가 같은 것은 id, password가 모두 같음을 정의했다.
    func isCorrectUser(user: User) -> Bool {
        for element in users {
            if element == user {
                print("데이터가 존재합니다")
                return true
            }
        }
        return false
    }
    
    func idReduplicationCheck(id: String) -> Bool {
        return manager.idReduplicationCheck(id: id)
    }
    
    func nickNameReduplicationCheck(nickName: String) -> Bool {
        return manager.nickNameReduplicationCheck(nickName: nickName)
    }
    
    func addUser(_ user: User) {
        manager.addUser(user)
    }
    
    func deleteUser(_ user: User) {
        manager.deleteUser(user)
    }
    
    func updateUser(_ user: User) {
        manager.updateUser(user)
    }
    
    func loadTaskUsers() {
        manager.retrieveUser()
    }
}
