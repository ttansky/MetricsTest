//
//  ViewController.swift
//  MetricsTest
//
//  Created by Тарас on 03.09.2020.
//  Copyright © 2020 Тарас. All rights reserved.
//

import UIKit

class MetricsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var metricsTableView: UITableView!
    @IBOutlet weak var sendMetricsButton: UIButton!
    
    //MARK: - Variables
    private var metrics: MetricsModel? {
        didSet {
            DispatchQueue.main.async {
                self.sendMetricsButton.isHidden = false
            }
        }
    }
    private var metricsDictionary = [String: Int?]()
    private var userToken: String?
    private lazy var isMetricsSent = false
    private var activityIndicator = UIActivityIndicatorView()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        getMetrics()
        metricsTableView.delegate = self
        metricsTableView.dataSource = self
        metricsTableView.register(UINib(nibName: "MetricsTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "MetricsTableViewHeader")
        metricsTableView.register(UINib(nibName: "MerticsTableViewCell", bundle: nil), forCellReuseIdentifier: "MerticsTableViewCell")
        metricsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    }
    
    //MARK: - Actions
    private func getMetrics() {
        showIndicator()
        NetworkService.getAuthToken { (token, error) in
            if let error = error {
                ErrorAlertService.showErrorAlert(in: self, error: error)
                self.hideIndicator()
            } else {
                self.userToken = token
                if let token = self.userToken {
                    NetworkService.signUpUser(token: token) { (error) in
                        if let error = error {
                            ErrorAlertService.showErrorAlert(in: self, error: error)
                            self.hideIndicator()
                        } else {
                            NetworkService.chooseProgram(token: token) { (id, error)  in
                                if let error = error {
                                    ErrorAlertService.showErrorAlert(in: self, error: error)
                                    self.hideIndicator()
                                } else {
                                    NetworkService.getWeekTrainings(token: token, purchaseId: id!) { (metrics, error) in
                                        if let error = error {
                                            ErrorAlertService.showErrorAlert(in: self, error: error)
                                            self.hideIndicator()
                                        } else if let metrics = metrics {
                                            self.metrics = metrics
                                            self.metricsDictionary = metrics.dictionary
                                            self.userToken = token
                                            DispatchQueue.main.async {
                                                self.metricsTableView.reloadData()
                                                self.activityIndicator.stopAnimating()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    self.hideIndicator()
                    ErrorAlertService.showErrorAlert(in: self, error: "Токен не найден")
                }
            }
        }
    }
    
    
    @IBAction func sendMetricsButtonPressed(_ sender: UIButton) {
        guard let metrics = metrics else { return }
        if self.metricsDictionary.count < metrics.arrayOfNames.count {
            let alert = UIAlertController(title: "Введите все замеры", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Oк", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.activityIndicator.startAnimating()
            NetworkService.sendMetrics(token: userToken!, metricId: metrics.id!, userMetrics: self.metricsDictionary) { (result, error) in
                if let error = error {
                    ErrorAlertService.showErrorAlert(in: self, error: error)
                    self.hideIndicator()
                } else {
                    self.isMetricsSent = result
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.metricsTableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func showIndicator() {
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func hideIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

//MARK: - TableView Delegate Methods
extension MetricsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Введите ваши замеры", message: "", preferredStyle: .alert)
        guard let metrics = self.metrics else { return }
        alert.addTextField { (textField) in
            textField.placeholder = MetricTranslator.translateMetricName(metric: metrics.arrayOfNames[indexPath.row])
            textField.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Oк", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields![0] {
                self.metricsDictionary[metrics.arrayOfNames[indexPath.row]] = Int(textField.text!)
                self.metricsTableView.reloadRows(at: [indexPath], with: .fade)
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - TableView DataSource Methods
extension MetricsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let metrics = metrics {
            return metrics.arrayOfNames.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MerticsTableViewCell") as! MerticsTableViewCell
        if let metrics = metrics {
            cell.metricNameLabel.text = MetricTranslator.translateMetricName(metric: metrics.arrayOfNames[indexPath.row])
            if let value = metricsDictionary[metrics.arrayOfNames[indexPath.row]] {
                if let value = value {
                    cell.metricValueLabel.text = "\(value)"
                    cell.metricsValueTypeLabel.textColor = .black
                }
            }
            cell.metricsValueTypeLabel.text = metrics.arrayOfNames[indexPath.row] == "weight" ? "кг" : "см"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MetricsTableViewHeader" ) as! MetricsTableViewHeader
        if metrics == nil {
            return nil
        }
        if isMetricsSent {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "d MMMM"
            headerView.topLabelText = "На \(formatter.string(from: Date()))"
            headerView.bottomLabelText = "Следующие замеры через 7 дней"
        } else {
            headerView.topLabelText = "Еще нет данных"
            headerView.bottomLabelText = "Сделай это прямо сейчас"
        }
        headerView.layoutSubviews()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return metrics != nil ? 110 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}

