//
//  LocaleViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/02.
//

import UIKit

struct LocaleViewModel {
    
    // MARK: Properties
    var regionalTableViewHeight: CGFloat {
        (numOfRegion <= 6) ?
        CGFloat(numOfRegion + 1) * 40.0 :
        300.0
    }
    var numOfRegion: Int { regionalList.count }
    var numOfMetropolis: Int { metropolisList.count }
    var selectedRegionIndex: Int {
        let region = UserDefaults.standard.string(forKey: "region") ?? "서울"
        return regionalList.firstIndex(of: region) ?? 0
    }
    
    var selectedMetropolisIndex: Int {
        let metropolis = UserDefaults.standard.string(forKey: "metropolis") ?? "서울"
        return metropolisList.firstIndex(of: metropolis) ?? 0
    }
    
    var selectedMetropolis: String {
        return UserDefaults.standard.string(forKey: "metropolis") ?? "서울"
    }
    
    var regionalList: [String] {
        return [selectedMetropolis] + districts
            .filter { $0.metropolisList == selectedMetropolis }
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
