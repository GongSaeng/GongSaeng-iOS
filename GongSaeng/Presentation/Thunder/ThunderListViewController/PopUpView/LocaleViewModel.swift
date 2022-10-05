//
//  Locale2ViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/21.
//

import UIKit

struct LocaleViewModel {
    
    // MARK: Properties
    let metropolis: String
    let region: String
    
    var regionalTableViewHeight: CGFloat {
        (numOfRegion <= 6) ?
        CGFloat(numOfRegion + 1) * 40.0 :
        300.0
    }
    var numOfRegion: Int { regionalList.count }
    var numOfMetropolis: Int { metropolisList.count }
    var selectedRegionIndex: Int {
        return regionalList.firstIndex(of: region) ?? 0
    }
    
    var selectedMetropolisIndex: Int {
        return metropolisList.firstIndex(of: metropolis) ?? 0
    }
    
    var regionalList: [String] {
        return [metropolis] + districts
            .filter { $0.metropolisList == metropolis }
            .flatMap { $0.localList }
    }
    
    var metropolisList: [String] {
        return districts.map { $0.metropolisList }
    }
    
    
    private var districts: [District] {
        guard let jsonData = loadJSON(),
              let districtJSON =
                try? JSONDecoder().decode(DistrictJSON.self, from: jsonData) else { return [] }
        return districtJSON.data
    }
    
    init(metropolis: String, region: String) {
        self.metropolis = metropolis
        self.region = region
    }
    
    // MARK: API
    private func loadJSON() -> Data? {
        let fileName = "korea_administrative_district"
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
}
