//
//  PredictOfDayVC.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

class PredictOfDayVC: UIViewController {
    
    let headerView = BOHeaderView(frame: .zero)
    
    let stackView = UIStackView()
    let predictOne = BOPredictionView(frame: .zero)
    let predictTwo = BOPredictionView(frame: .zero)
    let predictThree = BOPredictionView(frame: .zero)
    

    
    //Dummy predictions
    var predictions = [Prediction(date: "27 Ekim 2020 16:00", name: "Fenerbahce - Besiktas", organization: "Super Lig", prediction: "2.5 ust", odd: "1.5", isFree: false, price: 1),
                       Prediction(date: "27 Ekim 2020 23:00", name: "Manchester United - Real Madrid", organization: "UEFA Sampiyonlar Ligi", prediction: "2", odd: "2.00", isFree: true, price: 0),
                       Prediction(date: "27 Ekim 2020 23:00", name: "Sivasspor - Villereal", organization: "UEFA Avrupa Ligi", prediction: "3.5 ust", odd: "1.80", isFree: true, price: 0)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureHeaderView()
        configurePredictViews()
    }
    
    private func configureViewController() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.03, green: 0.46, blue: 0.44, alpha: 1.00)]
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func configureHeaderView() {
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configurePredictViews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        let predictionViewArray = [predictOne, predictTwo, predictThree]
        for (index, predictView) in predictionViewArray.enumerated() {
            stackView.addArrangedSubview(predictView)
            predictView.set(predict: predictions[index])
        }
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20)
        ])
    }
   
}
