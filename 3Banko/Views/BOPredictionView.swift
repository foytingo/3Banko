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
    let predictionBoxView = BOPredictionSubView(title: "Prediction")
    let oddBoxView = BOPredictionSubView(title: "Odd")
    

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
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 15
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill

        
        predictionBoxStackView.axis = .horizontal
        predictionBoxStackView.spacing = 20
        predictionBoxStackView.distribution = .fillEqually
        predictionBoxStackView.translatesAutoresizingMaskIntoConstraints = false
        predictionBoxStackView.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .vertical)
        predictionBoxStackView.addArrangedSubview(predictionBoxView)
        predictionBoxStackView.addArrangedSubview(oddBoxView)
        
        let labelArray = [dateLabel, matchLabel, organizationLabel, predictionBoxStackView]
        for label in labelArray {
            stackView.addArrangedSubview(label)
        }
        
        
    }
    
    private func layoutUI() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //stackView.backgroundColor = .systemRed
        NSLayoutConstraint.activate([
           
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
    }
}
