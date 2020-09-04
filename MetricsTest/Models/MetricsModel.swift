//
//  MetricsModel.swift
//  MetricsTest
//
//  Created by Тарас on 04.09.2020.
//  Copyright © 2020 Тарас. All rights reserved.
//

import Foundation

struct MetricsModel: Codable {
    var id: String?
    var weight: Int?
    var chest: Int?
    var shoulders: Int?
    var hips: Int?
    var waist: Int?
    var stomach: Int?
    
    var arrayOfNames: [String] {
        return ["weight", "shoulders", "chest", "waist", "stomach", "hips"]
    }

    var dictionary: [String: Int?] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Int?] ?? [:]
    }
}
