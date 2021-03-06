//
//  SingleOldPredictVC.swift
//  3Banko
//
//  Created by Murat Baykor on 29.10.2020.
//

import UIKit

class SingleOldPredictVC: UIViewController {

    var predict: [String: Any]?
    
    let stackView = UIStackView()
    let predictOne = BOPredictionView(frame: .zero)
    let predictTwo = BOPredictionView(frame: .zero)
    let predictThree = BOPredictionView(frame: .zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configurePredictViews()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popToRootViewController(animated: true)
    }

    
    private func configure() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = Color.BOGreen
    }
    
    
    private func configurePredictViews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        let predictionViewArray = [predictOne, predictTwo, predictThree]
        
        for (index, predictView) in predictionViewArray.enumerated() {
            stackView.addArrangedSubview(predictView)
            predictView.set(predict: predict!["predict\(index + 1)"] as! [String : Any], isOld: true)
        }
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20)
        ])
    }
    
    
}
