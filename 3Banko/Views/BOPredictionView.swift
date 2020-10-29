//
//  BOPredictionView.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

protocol BOPredictionViewDelegate: class {
    func didTapShowPredictButton() -> Bool
}

class BOPredictionView: UIView {

    let stackView = UIStackView()
    let dateLabel = BOSmallLabel(frame: .zero)
    let matchLabel = BOLabel(frame: .zero)
    let organizationLabel = BOSmallLabel(frame: .zero)

    let predictionBoxStackView = UIStackView()
    let predictionBoxView = BOPredictionSubView(title: "Tahmin")
    let oddBoxView = BOPredictionSubView(title: "Oran")
    
    @objc let showPredictButton = BOButton(frame: .zero)

    
    weak var predictViewDelegate: BOPredictionViewDelegate!

    var predictBoxIsShowed: Bool = false
    var predictUid: String? {
        didSet {
            guard let predictUid = predictUid else { return }
            predictBoxIsShowed = defaults.bool(forKey: predictUid)
            print("DEBUG: predict \(predictUid) loaded as \(predictBoxIsShowed)")
        }
    }
    
    let defaults = UserDefaults.standard
    
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
        if self.predictViewDelegate.didTapShowPredictButton() {
            guard let predictUid = predictUid else { return }
            
            predictBoxIsShowed = true
            defaults.set(predictBoxIsShowed, forKey: predictUid)
            print("DEBUG: predictBoxIsshowed saved as \(predictBoxIsShowed)")
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.showPredictButton.alpha = 0
            }) { finished in
                self.showPredictButton.isHidden = true
                self.showPredictBoxAnimation()
            }
        } else {
            print("DEBUG: Present alert with earn coin button and ok button.")
        }
        
    }
    
    @objc func showPredictBoxAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.predictionBoxStackView.alpha = 1
        })
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
    
    
    
    func set(predict: [String: Any], isOld: Bool) {
        dateLabel.text = (predict["date"] as! String)
        matchLabel.text = (predict["name"] as! String)
        organizationLabel.text = (predict["organization"] as! String)
        predictionBoxView.contentLabel.text = (predict["prediction"] as! String)
        oddBoxView.contentLabel.text = (predict["odd"] as! String)
        predictUid = predict["uuid"] as? String
        
        
        if (predict["isFree"] as! Bool) {
            showPredictButton.isHidden = true
            predictionBoxStackView.alpha = 1
            
        } else if predictBoxIsShowed {
            showPredictButton.isHidden = true
            predictionBoxStackView.alpha = 1
        } else if isOld {
            showPredictButton.isHidden = true
            predictionBoxStackView.alpha = 1
        }
    }
    

}

