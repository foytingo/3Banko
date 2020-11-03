//
//  BOLabel.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

class BOLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        let fontSize: CGFloat = DeviceTypes.isiPhone8orSE2Standard || DeviceTypes.isiPhone8orSE2Zoomed ? 18 : 22
        textAlignment = .center
        font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        translatesAutoresizingMaskIntoConstraints = false
        
    }

}
