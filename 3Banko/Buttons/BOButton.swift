//
//  BOButton.swift
//  3Banko
//
//  Created by Murat Baykor on 28.10.2020.
//

import UIKit

class BOButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            if imageView != nil {
                imageEdgeInsets = UIEdgeInsets(top: 8, left: (bounds.width - 35), bottom: 8, right: 10)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
            }
        }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 0.03, green: 0.46, blue: 0.44, alpha: 1.00)
        setTitle("Tahmini Goster", for: .normal)
        setImage(UIImage(named: "coins"), for: .normal)
        layer.cornerRadius = 10
    }
}
