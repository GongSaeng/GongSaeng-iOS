//
//  UniversityViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/09.
//

import Foundation

struct UniversityViewModel {
    var cellViewModelList: [UniversityCellViewModel] = []
    
    var searchedUniversities: [University] { return searchUniversitiesAPI() }
    
    var canSearch: Bool { searchBarText != searchedText }
    
    var searchBarText: String = ""
    var searchedText: String = ""
    
    var changedRowList: [Int] = []
    var selectedRow: Int?
    var selectedUniversity: University? {
        return selectedRow.flatMap { searchedUniversities[$0] }
    }
    var hasSelectedCell: Bool { selectedUniversity != nil }
    var shouldActivateButton: Bool { hasSelectedCell }
    
    private var universities: [University] {
        guard let jsonData = loadJSON(),
              let universityList =
                try? JSONDecoder().decode([University].self, from: jsonData) else { return [] }
        return universityList
    }
    
    // MARK: API
    private func loadJSON() -> Data? {
        let fileName = "domains_universities_in_korea"
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
    
    private func searchUniversitiesAPI() -> [University] {
        guard !searchBarText.isEmpty else { return universities }
        return universities.filter { $0.name.contains(searchBarText) }
    }
    
    mutating func updateCellViewModels() {
        cellViewModelList = searchedUniversities.map { UniversityCellViewModel(university: $0) }
        selectedRow = nil
    }
    
    mutating func didSelectCell(at row: Int) {
        changedRowList = (selectedRow == row || selectedRow == nil) ? [row] : [row, selectedRow!]
        
        if let selectedRow = selectedRow,
           row != selectedRow,
           cellViewModelList[selectedRow].isSelected {
            cellViewModelList[selectedRow].toggleSelectedState()
        }
        
        cellViewModelList[row].toggleSelectedState()
        selectedRow = (selectedRow == row && !cellViewModelList[row].isSelected) ? nil : row
        
    }
}
