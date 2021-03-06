//
//  BOTabBarController.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

class BOTabBarController: UITabBarController {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        UITabBar.appearance().tintColor = Color.BOGreen
        viewControllers = [createPredictOfDayNC(), createOldPredictsNC()]
    }
    

    private func createPredictOfDayNC() -> UIViewController {
        let predictOfDayVC = PredictOfDayVC()
        predictOfDayVC.tabBarItem = UITabBarItem(title: "Günün Tahminleri", image: UIImage(systemName: "die.face.3.fill"), tag: 0)
        return predictOfDayVC
    }
    
    
    private func createOldPredictsNC() -> UINavigationController {
        let oldPredictsVC = OldPredictsVC()
        oldPredictsVC.title = "Eski Tahminler"
        oldPredictsVC.tabBarItem = UITabBarItem(title: "Eski Tahminler", image: UIImage(systemName: "clock.fill"), tag: 1)
        return UINavigationController(rootViewController: oldPredictsVC)
    }

}
