//
//  NetworkService.swift
//  MetricsTest
//
//  Created by Тарас on 04.09.2020.
//  Copyright © 2020 Тарас. All rights reserved.
//

import Foundation

class NetworkService {
    
    class func getAuthToken(completion: @escaping (String?, String?) -> ()) {
        guard let url = URL(string: Endpoints.basic.rawValue + Endpoints.getToken.rawValue) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    completion(nil, FailureResponseHandler.responseHandler(data: data))
                    return
                }
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let token = json?["token"] as? String {
                    completion(token, nil)
                }
            } catch let error {
                completion(nil, error.localizedDescription)
            }
        }.resume()
    }
    
    class func signUpUser(token: String, completion: @escaping (String?) -> ()) {
        guard let url = URL(string: Endpoints.basic.rawValue + Endpoints.signUp.rawValue) else { return }
        let body: [String: Any] = ["name": "Test Guy",
                    "phone": "+380661234567",
                    "weight": 80,
                    "needNotification": false,
                    "program": "666",
                    "activityHealth": 666,
                    "firToken": token,
                    "pushToken": UUID().uuidString]
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    completion(FailureResponseHandler.responseHandler(data: data))
                    return
                }
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let jsonError = json?["error"] as? String {
                    completion(jsonError)
                } else {
                    completion(nil)
                }
            } catch let error {
                completion(error.localizedDescription)
            }
        }.resume()
    }
    
    class func chooseProgram(token: String, completion: @escaping (String?, String?) -> ()) {
        guard let url = URL(string: Endpoints.basic.rawValue + Endpoints.chooseProgram.rawValue + "e95e9274-b673-434e-94f8-d16dad6bb8e2") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    completion(nil, FailureResponseHandler.responseHandler(data: data))
                    return
                }
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                completion(json?["id"] as? String, nil)
            } catch let error {
                completion(nil, error.localizedDescription)
            }
        }.resume()
    }
    
    class func getWeekTrainings(token: String, purchaseId: String, completion: @escaping (MetricsModel?, String?) -> ()) {
        guard let url = URL(string: Endpoints.basic.rawValue + Endpoints.weekTrainings.rawValue + "\(purchaseId)") else { return }
            let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(nil, error.localizedDescription)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if !(200...299).contains(httpResponse.statusCode) {
                        completion(nil, FailureResponseHandler.responseHandler(data: data))
                        return
                    }
                }
                guard let data = data else { return }
                do {
                    let weekArray = try JSONDecoder().decode(Array<WeekDayModel>.self, from: data)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd"
                    let today = dateFormatter.string(from: Date())
                        for day in weekArray {
                            if day.human == today {
                                completion(day.metric, nil)
                            }
                        }
                } catch let error {
                    completion(nil, error.localizedDescription)
                }
            }.resume()
        }
    
    class func sendMetrics(token: String, metricId: String, userMetrics: [String: Int?], completion: @escaping (Bool, String?) -> ()) {
        guard let url = URL(string: Endpoints.basic.rawValue + Endpoints.postMetrics.rawValue + "\(metricId)") else { return }
        let body = userMetrics
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    completion(false, FailureResponseHandler.responseHandler(data: data))
                    return
                }
            }
            guard let data = data else { return }
            let result = String(data: data, encoding: .utf8).flatMap(Bool.init)
            if let result = result {
                completion(result, nil)
            } else {
                completion(false, "Ошибка запроса")
            }
        }.resume()
    }
}
