//
//  BOPredictionSubBoxLabel.swift
//  3Banko
//
//  Created by Murat Baykor on 1.11.2020.
//

import UIKit

class BOPredictionSubBoxLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(fontSize: CGFloat, weight: UIFont.Weight, color: UIColor) {
        super.init(frame: .zero)
        configure()
        font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        textColor = color
    }
    
    
    private func configure() {
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }

}
