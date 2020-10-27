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
        layer.cornerRadius = 25
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        let labelArray = [dateLabel, matchLabel, organizationLabel]
        for label in labelArray {
            stackView.addArrangedSubview(label)
        }
    }
    
    private func layoutUI() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120)
        ])
    }
}
