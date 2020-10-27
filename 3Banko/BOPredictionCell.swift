//
//  BOPredictionCell.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

class BOPredictionCell: UITableViewCell {

    static let reuseID = "PredictionCell"
    
    let dateLabel = BOSmallLabel(frame: .zero)
    let matchLabel = BOLabel(frame: .zero)
    let organizationLabel = BOSmallLabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func configure() {
        addSubview(dateLabel)
        addSubview(matchLabel)
        addSubview(organizationLabel)
        
        backgroundColor = .tertiarySystemBackground
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            matchLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: padding),
            matchLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            matchLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            matchLabel.heightAnchor.constraint(equalToConstant: 30),
            
            organizationLabel.topAnchor.constraint(equalTo: matchLabel.bottomAnchor, constant: padding),
            organizationLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            organizationLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            organizationLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
            
        ])
    }

}
