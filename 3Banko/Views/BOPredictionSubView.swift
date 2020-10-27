//
//  BOPredictionSubView.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

class BOPredictionSubView: UIView {

    let stackView = UIStackView()
    let titleLabel = BOSmallLabel(frame: .zero)
    let contentLabel = BOSmallLabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        configure()
        layoutUI()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 10
        
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .equalSpacing

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
    }
    
    private func layoutUI() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            
        ])
    }
    
    
}
