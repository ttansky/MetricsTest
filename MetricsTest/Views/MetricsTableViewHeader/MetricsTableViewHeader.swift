//
//  MetricsTableViewHeader.swift
//  MetricsTest
//
//  Created by Тарас on 03.09.2020.
//  Copyright © 2020 Тарас. All rights reserved.
//

import UIKit

class MetricsTableViewHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var toplLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    var topLabelText: String?
    var bottomLabelText: String?
    
    private func setupLabels() {
        self.toplLabel.text = topLabelText
        self.bottomLabel.text = bottomLabelText
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLabels()
    }
}
