//
//  Endpoints.swift
//  MetricsTest
//
//  Created by Тарас on 04.09.2020.
//  Copyright © 2020 Тарас. All rights reserved.
//

import Foundation

enum Endpoints: String {
    case basic = "http://ec2-3-134-114-165.us-east-2.compute.amazonaws.com:3000/"
    case getToken = "auth/token"
    case signUp = "auth/signup"
    case chooseProgram = "purchase/"
    case weekTrainings = "calendar/week/"
    case postMetrics = "calendar/week/metric/"
    
}
