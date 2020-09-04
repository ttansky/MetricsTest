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
            return "Текущий вес"
        case "shoulders":
            return "Обхват плеча"
        case "chest":
            return "Обхват под грудью"
        case "waist":
            return "Талия"
        case "stomach":
            return "Живот"
        case "hips":
            return "Ягодицы"
        default:
           return metric
        }
    }
}
