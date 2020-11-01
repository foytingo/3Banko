//
//  OldPredictsVC.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

class OldPredictsVC: BODataLoadingViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let refreshButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
    
    var allPredictions = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureRefreshButton()
        configureNavBar()
        configureTableView()
        getAllPredicts()
    }
    
    
    private func configureRefreshButton() {
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.layer.cornerRadius = 10
        refreshButton.backgroundColor = Color.BOGreen
        refreshButton.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
        refreshButton.tintColor = .white
    }
    
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refreshButton)
    }
    
    
    @objc func refreshAction() {
        getAllPredicts()
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    private func getAllPredicts() {
        showLoadingView()
        FirebaseManager.shared.getAllPredictions { predictions, error in
            self.dismissLoadingView()
            guard let _ = error else {
                self.allPredictions = predictions
                self.tableView.reloadData()
                return
            }
            self.presentAlertWithOk(message: BOError.internetError.rawValue)
        }
    }
    
}


extension OldPredictsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPredictions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .tertiarySystemBackground
        cell.textLabel?.text = allPredictions[indexPath.row]["date"] as? String
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let singleOldPredictVC = SingleOldPredictVC()
        singleOldPredictVC.predict = allPredictions[indexPath.row]
        singleOldPredictVC.title = allPredictions[indexPath.row]["date"] as? String
        self.navigationController?.pushViewController(singleOldPredictVC, animated: true)
    }
    
}

