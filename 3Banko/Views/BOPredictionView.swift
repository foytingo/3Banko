//
//  BOPredictionView.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

class BOPredictionView: UIView {

    let stackView = UIStackView()
    let dateLabel = BOSmallLabel(frame: .zero)
    let matchLabel = BOLabel(frame: .zero)
    let organizationLabel = BOSmallLabel(frame: .zero)

    let predictionBoxStackView = UIStackView()
    let predictionBoxView = BOPredictionSubView(title: "Tahmin")
    let oddBoxView = BOPredictionSubView(title: "Oran")
    
    @objc let showPredictButton = BOButton(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 15
        
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillEqually

        predictionBoxStackView.axis = .horizontal
        predictionBoxStackView.spacing = 20
        predictionBoxStackView.distribution = .fillEqually
 
        let boxArray = [predictionBoxView, oddBoxView]
        for box in boxArray {
            predictionBoxStackView.addArrangedSubview(box)
        }
        
        let labelArray = [dateLabel, matchLabel, organizationLabel]
        for label in labelArray {
            stackView.addArrangedSubview(label)
        }
        
        showPredictButton.addTarget(self, action: #selector(showPredictButtonAction), for: .touchUpInside)
    }
    
    @objc func showPredictButtonAction() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.showPredictButton.alpha = 0
        }) { finished in
            self.showPredictButton.isHidden = true
            self.testFunc()
        }

    }
    
    @objc func testFunc() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.predictionBoxStackView.alpha = 1
            
        }) { finished in
            print("predict show; \(finished)")
            print("coin count --")
        }
    }
    
    private func layoutUI() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        addSubview(predictionBoxStackView)
        predictionBoxStackView.alpha = 0
        predictionBoxStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            predictionBoxStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            predictionBoxStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            predictionBoxStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            predictionBoxStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        addSubview(showPredictButton)
        NSLayoutConstraint.activate([
            showPredictButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            showPredictButton.centerYAnchor.constraint(equalTo: predictionBoxStackView.centerYAnchor),
            showPredictButton.widthAnchor.constraint(equalToConstant: 250),
            showPredictButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    
    func set(predict: Prediction) {
        dateLabel.text = predict.date
        matchLabel.text = predict.name
        organizationLabel.text = predict.organization
        predictionBoxView.contentLabel.text = predict.prediction
        oddBoxView.contentLabel.text = predict.odd
        
        if predict.isFree {
            showPredictButton.isHidden = true
            predictionBoxStackView.alpha = 1
            
        }
    }

}

