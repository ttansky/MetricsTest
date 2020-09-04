//
//  ErrorAlertService.swift
//  MetricsTest
//
//  Created by Тарас on 04.09.2020.
//  Copyright © 2020 Тарас. All rights reserved.
//

import UIKit

class ErrorAlertService {
    
    class func showErrorAlert(in viewController: UIViewController, error: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: error, message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Oк", style: UIAlertAction.Style.default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
