//
//  MerticsTableViewCell.swift
//  MetricsTest
//
//  Created by Тарас on 03.09.2020.
//  Copyright © 2020 Тарас. All rights reserved.
//

import UIKit

class MerticsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var metricNameLabel: UILabel!
    @IBOutlet weak var metricValueLabel: UILabel!
    @IBOutlet weak var metricsValueTypeLabel: UILabel!
    
    private func setupCell() {
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowOffset = CGSize(width: 7, height: 15)
        self.contentView.layer.shadowColor = UIColor(red: 0.4, green: 0.244, blue: 0.2, alpha: 0.04).cgColor
        self.contentView.layer.shadowOpacity = 1
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        metricValueLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupCell()
    }
    
}
