//
//  BOHeaderView.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

protocol BOHeaderViewDelegate: class {
    func didTapEarnCoinButton()
}

class BOHeaderView: UIView {

    let coinImageView = UIImageView(image: UIImage(named: "coins"))
    let coinCountLabel = BOSmallLabel(frame: .zero)
    let earnCoinButton = UIButton(type: .custom)
    
    weak var headerViewDelegate: BOHeaderViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 15
        
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        earnCoinButton.translatesAutoresizingMaskIntoConstraints = false
        earnCoinButton.setTitle("Jeton Kazan", for: .normal)
        earnCoinButton.layer.cornerRadius = 10
        earnCoinButton.backgroundColor = UIColor(red: 0.03, green: 0.46, blue: 0.44, alpha: 1.00)
        earnCoinButton.addTarget(self, action: #selector(earnCoinAction), for: .touchUpInside)
        
        addSubview(coinImageView)
        addSubview(coinCountLabel)
        addSubview(earnCoinButton)
        NSLayoutConstraint.activate([
            coinImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            coinImageView.widthAnchor.constraint(equalToConstant: 30),
            coinImageView.heightAnchor.constraint(equalToConstant: 30),
            
            coinCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinCountLabel.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: 10),
            
            earnCoinButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            earnCoinButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            earnCoinButton.widthAnchor.constraint(equalToConstant: 120),
            earnCoinButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func set(coinCount: Int) {
        coinCountLabel.text = "Jeton: \(coinCount)"
    }
    
    @objc func earnCoinAction() {
        headerViewDelegate.didTapEarnCoinButton()
    }

}
