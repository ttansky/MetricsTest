//
//  MetricTranslator.swift
//  MetricsTest
//
//  Created by Тарас on 04.09.2020.
//  Copyright © 2020 Тарас. All rights reserved.
//

import Foundation

//Чтобы не тратить время на Localizable.strings, использую этот класс для перевода названий метрик

class MetricTranslator {
    
    class func translateMetricName(metric: String) -> String {
        switch metric {
        case "weight":
            return "текущий вес"
        case "shoulders":
            return "обхват плеча"
        case "chest":
            return "обхват под грудью"
        case "waist":
            return "талия"
        case "stomach":
            return "живот"
        case "hips":
            return "ягодицы"
        default:
           return metric
        }
    }
}
