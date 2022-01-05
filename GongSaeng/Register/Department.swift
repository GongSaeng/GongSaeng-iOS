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
    var isDone: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case nameOfDepartment = "department_name"
        case addressOfDepartment = "department_detail"
    }
    
//    var isDone: Bool
    
//    mutating func update(name: String, address: String, isDone: Bool) {
//        self.nameOfDepartment = name
//        self.addressOfDepartment = address
//        self.isDone = isDone
//    }
    
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        return lhs.nameOfDepartment == rhs.nameOfDepartment && lhs.addressOfDepartment == rhs.addressOfDepartment && lhs.isDone == rhs.isDone
//    }
}

class DepartmentViewModel {
    var isDoneName: String = ""
    
    var departments: [Department] = []
    
    var searchedDepartments: [Department] = []
    
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
    
        func changeIsDoneToFalse() {
            guard numOfSearchDepartment > 0, isDoneName != "" else { return }
            for index in 0..<numOfSearchDepartment {
                if searchedDepartments[index].nameOfDepartment == isDoneName {
                    searchedDepartments[index].isDone = false
                    return
                }
            }
        }
    
        func returnIsDoneIndex() -> Int? {
            guard numOfSearchDepartment > 0, isDoneName != "" else { return nil }
            for index in 0..<numOfSearchDepartment {
                if searchedDepartments[index].nameOfDepartment == isDoneName {
                    return index
                }
            }
            return nil
        }
    
        func loadDatas() {
            self.searchedDepartments = self.departments
        }
    
    
//    var isDoneName: String = ""
//    
//    var departments: [Department] = [
//        Department(nameOfDepartment: "한국장학재단 부산센터", addressOfDepartment: "부산광역시 연제구 반송로 60"),
//        Department(nameOfDepartment: "한국장학재단 서울센터", addressOfDepartment: "서울특별시 중구 장충단로6길 54"),
//        Department(nameOfDepartment: "한국장학재단 대구센터", addressOfDepartment: "대구광역시 중구 명륜로23길 89"),
//        Department(nameOfDepartment: "한국장학재단 대전센터", addressOfDepartment: "대전광역시 중구 계룡로 843"),
//        Department(nameOfDepartment: "한국장학재단 경기센터", addressOfDepartment: "경기도 수원시 영통구 광교산로 154-42"),
//        Department(nameOfDepartment: "한국장학재단 강원센터", addressOfDepartment: "강원도 춘천시 강원대학길 1 공과대학 6호관 2층 214호"),
//        Department(nameOfDepartment: "부산대학교 자유관", addressOfDepartment: "부산광역시 금정구 부산대학로63번길 2"),
//        Department(nameOfDepartment: "부산대학교 웅비관", addressOfDepartment: "부산광역시 금정구 부산대학로63번길 2"),
//        Department(nameOfDepartment: "부산대학교 진리관", addressOfDepartment: "부산광역시 금정구 부산대학로63번길 2")
//    ]
//    
//    var searchedDepartments: [Department] = [] // 검색된 결과를 여기에 넣도록 하자.
//    
//    var numOfDepartments: Int {
//        return departments.count
//    }
//    
//    var numOfSearchDepartment: Int {
//        return searchedDepartments.count
//    }
//    
//    func searchDepartmentOfIndex(at index: Int) -> Department {
//        return searchedDepartments[index]
//    }
//    
//    func isDoneDepartment() -> Bool {
//        // department의 isDone이 true인 한 놈을 있으면 true, 없다면 false
//        let doneDepartments = searchedDepartments.filter { $0.isDone == true }
//        if doneDepartments == [] {
//            isDoneName = ""
//            return false
//        } else {
//            isDoneName = doneDepartments[0].nameOfDepartment
//            return true
//        }        
//    }
//    
//    func changeIsDoneToFalse() {
//        guard numOfSearchDepartment > 0, isDoneName != "" else { return }
//        for index in 0..<numOfSearchDepartment {
//            if searchedDepartments[index].nameOfDepartment == isDoneName {
//                searchedDepartments[index].isDone = false
//                return
//            }
//        }
//    }
//    
//    func returnIsDoneIndex() -> Int? {
//        guard numOfSearchDepartment > 0, isDoneName != "" else { return nil }
//        for index in 0..<numOfSearchDepartment {
//            if searchedDepartments[index].nameOfDepartment == isDoneName {
//                return index
//            }
//        }
//        return nil
//    }
//    
//    func loadDatas() {
//        self.searchedDepartments = self.departments
//    }
}
