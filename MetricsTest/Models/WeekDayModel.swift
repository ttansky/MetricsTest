//
//  WeekDayModel.swift
//  MetricsTest
//
//  Created by Тарас on 04.09.2020.
//  Copyright © 2020 Тарас. All rights reserved.
//

import Foundation

struct WeekDayModel: Decodable {
    var human: String
    var metric: MetricsModel?
}
