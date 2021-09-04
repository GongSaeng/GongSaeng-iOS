//
//  Department.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/23.
//

import Foundation

struct Department: Codable, Equatable {
    var nameOfDepartment: String
    var addressOfDepartment: String
    var isDone: Bool
    
    mutating func update(name: String, address: String, isDone: Bool) {
        self.nameOfDepartment = name
        self.addressOfDepartment = address
        self.isDone = isDone
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.nameOfDepartment == rhs.nameOfDepartment && lhs.addressOfDepartment == rhs.addressOfDepartment && lhs.isDone == rhs.isDone
    }
}

class DepartmentViewModel {
    var isDoneName: String = ""
    
    var departments: [Department] = [
        Department(nameOfDepartment: "한국장학재단 부산센터", addressOfDepartment: "부산광역시 연제구 반송로 60", isDone: false),
        Department(nameOfDepartment: "한국장학재단 서울센터", addressOfDepartment: "강남?", isDone: false),
        Department(nameOfDepartment: "한국장학재단 대구센터", addressOfDepartment: "갓대구", isDone: false),
        Department(nameOfDepartment: "부산대학교 자유관", addressOfDepartment: "새도 앞", isDone: false),
        Department(nameOfDepartment: "부산대학교 웅비관", addressOfDepartment: "저~ 산꼭대기", isDone: false),
        Department(nameOfDepartment: "부산대학교 진리관", addressOfDepartment: "저~ 웅비관 옆", isDone: false)
    ]
    
    var searchedDepartments: [Department] = [] // 검색된 결과를 여기에 넣도록 하자.
    
    var numOfDepartments: Int {
        return departments.count
    }
    
    var numOfSearchDepartment: Int {
        return searchedDepartments.count
    }
    
    func searchDepartmentOfIndex(at index: Int) -> Department {
        return searchedDepartments[index]
    }
    
    func isDoneDepartment() -> Bool {
        // department의 isDone이 true인 한 놈을 있으면 true, 없다면 false
        let doneDepartments = searchedDepartments.filter { $0.isDone == true }
        if doneDepartments == [] {
            isDoneName = ""
            return false
        } else {
            isDoneName = doneDepartments[0].nameOfDepartment
            return true
        }        
    }
    
    func loadDatas() {
        self.searchedDepartments = self.departments
    }
}
