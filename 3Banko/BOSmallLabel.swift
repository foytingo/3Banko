//
//  BOSmallLabel.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

class BOSmallLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textColor = .systemGray
        
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        translatesAutoresizingMaskIntoConstraints = false
        
    }

}
