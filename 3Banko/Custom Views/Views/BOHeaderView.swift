//
//  BOHeaderView.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

enum CoinCase {
    case up, down
}

protocol BOHeaderViewDelegate: class {
    func didTapEarnCoinButton()
    func didTapRefreshButton()
}

class BOHeaderView: UIView {

    let coinImageView = UIImageView(image: UIImage(named: "coins"))
    let coinCountLabel = BOSmallLabel(frame: .zero)
    let earnCoinButton = UIButton(type: .custom)
    let refreshButton = UIButton(type: .custom)
    let arrowImageView = UIImageView()
    
    
    weak var headerViewDelegate: BOHeaderViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 15
    
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        earnCoinButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        earnCoinButtonStatus(isActive: false)
        earnCoinButton.setTitle("Jeton Kazan", for: .normal)
        earnCoinButton.layer.cornerRadius = 10
        earnCoinButton.addTarget(self, action: #selector(earnCoinAction), for: .touchUpInside)
        
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.layer.cornerRadius = 10
        refreshButton.backgroundColor = Color.BOGreen
        refreshButton.tintColor = .white
        refreshButton.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
        
        addSubview(coinImageView)
        addSubview(coinCountLabel)
        addSubview(arrowImageView)
        addSubview(earnCoinButton)
        addSubview(refreshButton)
        
        NSLayoutConstraint.activate([
            coinImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            coinImageView.widthAnchor.constraint(equalToConstant: 30),
            coinImageView.heightAnchor.constraint(equalToConstant: 30),
            
            coinCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinCountLabel.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: 8),
            
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: coinCountLabel.trailingAnchor, constant: 5),
            arrowImageView.widthAnchor.constraint(equalToConstant: 15),
            arrowImageView.heightAnchor.constraint(equalToConstant: 15),
            
            refreshButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            refreshButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            refreshButton.widthAnchor.constraint(equalToConstant: 40),
            refreshButton.heightAnchor.constraint(equalToConstant: 30),
            
            earnCoinButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            earnCoinButton.trailingAnchor.constraint(equalTo: refreshButton.leadingAnchor, constant: -10),
            earnCoinButton.widthAnchor.constraint(equalToConstant: 120),
            earnCoinButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    func set(coinCount: Int) {
        coinCountLabel.text = "Jeton: \(coinCount)"
        configure()
    }
    
    
    func earnCoinButtonStatus(isActive: Bool) {
        if isActive {
            self.earnCoinButton.isEnabled = true
            self.earnCoinButton.backgroundColor = Color.BOGreen
        } else {
            self.earnCoinButton.isEnabled = true
            self.earnCoinButton.backgroundColor = .systemGray
        }
    }
    
    
    func coinUpAndDownAnimation(coinCase: CoinCase) {
        var labelColor: UIColor = Color.BOGreen
        
        switch coinCase {
        case .up:
            arrowImageView.image = UIImage(named: "upArrow")
            labelColor = Color.BOGreen
        case .down:
            arrowImageView.image = UIImage(named: "downArrow")
            labelColor = Color.BORed
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.125, options: [.curveEaseInOut]) {
            self.coinCountLabel.textColor = labelColor
            
            UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true) {
                self.arrowImageView.alpha = 0
            }
        } completion: { (_) in
            
            self.coinCountLabel.textColor = .systemGray
            self.arrowImageView.alpha = 1
            self.arrowImageView.image = nil
        }
    }
    
    
    
    @objc func earnCoinAction() {
        headerViewDelegate.didTapEarnCoinButton()
    }
    
    @objc func refreshAction() {
        headerViewDelegate.didTapRefreshButton()
    }

}
