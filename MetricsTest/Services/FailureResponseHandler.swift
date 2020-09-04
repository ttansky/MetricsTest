//
//  FailureResponseHandler.swift
//  MetricsTest
//
//  Created by Тарас on 04.09.2020.
//  Copyright © 2020 Тарас. All rights reserved.
//

import Foundation

class FailureResponseHandler {
    class func responseHandler(data: Data?) -> String {
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let jsonError = json?["message"] as? String {
                    return jsonError
                } else {
                    return "Произошла неизвестная ошибка"
                }
            } catch let error {
                return error.localizedDescription
            }
        }
        return "Произошла неизвестная ошибка"
    }
}
