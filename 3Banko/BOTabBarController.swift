//
//  BOTabBarController.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

class BOTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createPredictOfDayNC(), createOldPredictsNC()]
    }
    

    private func createPredictOfDayNC() -> UINavigationController {
        let predictOfDayVC = PredictOfDayVC()
        predictOfDayVC.title = "Predicts of day"
        predictOfDayVC.tabBarItem = UITabBarItem(title: "Predicts of day", image: UIImage(systemName: "die.face.3.fill"), tag: 0)
        return UINavigationController(rootViewController: predictOfDayVC)
    }
    
    private func createOldPredictsNC() -> UINavigationController {
        let oldPredictsVC = OldPredictsVC()
        oldPredictsVC.title = "Old Predicts"
        oldPredictsVC.tabBarItem = UITabBarItem(title: "Predicts of day", image: UIImage(systemName: "clock.fill"), tag: 1)
        return UINavigationController(rootViewController: oldPredictsVC)
    }

}
