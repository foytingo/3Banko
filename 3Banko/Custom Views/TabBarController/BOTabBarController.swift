//
//  BOTabBarController.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit

class BOTabBarController: UITabBarController {

    var userUid: String? {
        didSet {
            let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
            
            if launchedBefore == false {
                FirebaseManager.shared.firstLaunchOption(with: userUid!) { error in
                    guard error != nil else {
                        UserDefaults.standard.set(true, forKey: "launchedBefore")
                        return
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        FirebaseManager.shared.authAnonymous { (error) in
            guard error != nil else {
                guard let userUid = FirebaseManager.shared.getSingedUserUid() else { return }
                self.userUid = userUid
                return
            }

        }
        
        
        
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
