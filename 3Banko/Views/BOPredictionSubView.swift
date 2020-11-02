//
//  BOPredictionSubView.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

enum SubViewType {
    case prediction, odd, result
}

class BOPredictionSubView: UIView {

    let stackView = UIStackView()
    let titleLabel = BOPredictionSubBoxLabel(fontSize: 14, weight: .regular, color: .systemGray)
    let contentLabel = BOPredictionSubBoxLabel(fontSize: 17, weight: .regular, color: .label)
    
    var type: SubViewType?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(title: String, type: SubViewType) {
        super.init(frame: .zero)
        titleLabel.text = title
        self.type = type
        configure()
        layoutUI()
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
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
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    
    func set(predict: [String: Any]) {
        switch type {
        case .prediction:
            contentLabel.text = (predict["prediction"] as! String)
        case .odd:
            contentLabel.text = (predict["odd"] as! String)
        case .result:
            contentLabel.text = (predict["result"] as! String)
        case .none:
            contentLabel.text = "-"
        }
    }
    
    
}
