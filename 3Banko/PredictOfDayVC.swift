//
//  PredictOfDayVC.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

class PredictOfDayVC: UIViewController {
    
    let stackView = UIStackView()
    let predictOne = BOPredictionView(frame: .zero)
    let predictTwo = BOPredictionView(frame: .zero)
    let predictThree = BOPredictionView(frame: .zero)
    
    //Dummy predictions
    var predictions = [Prediction(date: "27 Ekim 2020 16:00", name: "Fenerbahce - Besiktas", organization: "Super Lig"), Prediction(date: "27 Ekim 2020 23:00", name: "Manchester United - Real Madrid", organization: "UEFA Sampiyonlar Ligi"), Prediction(date: "27 Ekim 2020 23:00", name: "Sivasspor - Villereal", organization: "UEFA Avrupa Ligi")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configurePredictViews()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    
    private func configurePredictViews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        let predictionViewArray = [predictOne, predictTwo, predictThree]
        for (index, predictView) in predictionViewArray.enumerated() {
            stackView.addArrangedSubview(predictView)
            predictView.dateLabel.text = predictions[index].date
            predictView.matchLabel.text = predictions[index].name
            predictView.organizationLabel.text = predictions[index].organization
        }
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20)
        ])
    }
   
}
