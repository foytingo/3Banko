//
//  UIViewController+Ext.swift
//  3Banko
//
//  Created by Murat Baykor on 30.10.2020.
//

import UIKit

extension UIViewController {
    
    func presentAlertWithOk(message: String) {
        let ac = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(ac, animated: true)
    }
}
