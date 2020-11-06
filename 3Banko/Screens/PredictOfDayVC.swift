//
//  PredictOfDayVC.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit
import GoogleMobileAds
import Network
//import Firebase
import AppTrackingTransparency

class PredictOfDayVC: BODataLoadingViewController {
    
    let monitor = NWPathMonitor()
    
    let headerView = BOHeaderView(frame: .zero)
    
    let stackView = UIStackView()
    let predictOne = BOPredictionView(frame: .zero)
    let predictTwo = BOPredictionView(frame: .zero)
    let predictThree = BOPredictionView(frame: .zero)
    
    var didEarnCoin = false
    var rewardedAd: GADRewardedAd?
    
    var predictions: [String: Any]? {
        didSet {
            
            configurePredictViews()
           
        }
    }

    var userUid: String? {
        didSet {
            print("DEBUG: Logged userUid as \(self.userUid!)")
            
            let launcedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
            
            print("DEBUG: Did this app lauch before: \(launcedBefore)")
            
            if launcedBefore == false {
                print("DEBUG: This time is first time.")
                FirebaseManager.shared.firstLaunchOption(with: userUid!) { error in
                    if let error = error {
                        print("DEBUG: First launch option did not complete with error: \(error)")
                    } else {
                        print("DEBUG: First launch option completed and launcedBefore setted as true and savedUserUid set as \(self.userUid!)")
                        UserDefaults.standard.set(true, forKey: "launchedBefore")
                        UserDefaults.standard.set(self.userUid!, forKey: "savedUserUid")
                        print("DEBUG: Start first user data get.")
                        self.getUserData(userUid: self.userUid!)
                        print("DEBUG: Start geting prediction")
                        self.getDailyPredictions()
                    }
                }
            } else {
                print("DEBUG: This time is NOT first time.")
                let savedUserUid = UserDefaults.standard.string(forKey: "savedUserUid")
                getUserData(userUid: savedUserUid)
                print("DEBUG: Read savedUserUid:(\(savedUserUid ?? "This should be userUid")) and start get user data")
                print("DEBUG: Start geting prediction")
                self.getDailyPredictions()
            }
            

        }
    }
    
    
    
    
    var coinCount: Int = 0 {
        didSet {
            headerView.set(coinCount: coinCount)
            configureHeaderView()
        }
    }
    
    
    var user: BOUser? {
        didSet {
            guard let user = user else { return }
            self.coinCount = user.coinCount
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        showLoadingView()
        
        FirebaseManager.shared.authAnonymous { userUid, error in
            print("DEBUG: Start auth process.")
            if let error = error {
                print("DEBUG: Signed not completed. Error: \(error)")
            } else {
                print("DEBUG: Signed successfully completed. UserUID: \(userUid ?? "This should be userUid.")")
                self.userUid = userUid
                //print("DEBUG: Start getDailyPredictions")
                //self.getDailyPredictions()
            }
        }
        
        
//        let signedUserUid = FirebaseManager.shared.getSingedUserUid()
//
//        if signedUserUid == nil {
//            print("DEBUG: Signed user not found. Start auth process.")
//
//            FirebaseManager.shared.authAnonymous { (userUid, error) in
//                if let error = error {
//                    print("DEBUG: Signed not completed. Error: \(error)")
//                } else {
//                    print("DEBUG: Signed successfully completed. UserUID: \(userUid ?? "This should be userUid.")")
//                    self.userUid = userUid
//                    print("DEBUG: Start getDailyPredictions")
//                    self.getDailyPredictions()
//                }
//            }
//        } else {
//            print("DEBUG: Signed user was found. UserUID: \(signedUserUid ?? "This should be userUid.")")
//            self.userUid = signedUserUid
//            print("DEBUG: Start getDailyPredictions")
//            getDailyPredictions()
//        }
        
        
        configureViewController()
        
        requestIDFA()
        
    }

    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                print(status.rawValue)
                self.rewardedAd = self.createAndLoadRewardedAd()
            }
        } else {
            rewardedAd = createAndLoadRewardedAd()
        }
    }
    
    
    func checkConnection() -> Bool {
        return monitor.currentPath.status == .unsatisfied ? false : true
    }
    
    
    private func configureViewController() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    
    private func configureHeaderView() {
        view.addSubview(headerView)
        headerView.headerViewDelegate = self
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func configurePredictViews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        let predictionViewArray = [predictOne, predictTwo, predictThree]
        for (index,predictView) in predictionViewArray.enumerated() {
            stackView.addArrangedSubview(predictView)
            predictView.predictViewDelegate = self
            predictView.set(predict: predictions!["predict\(index + 1)"] as! [String : Any], isOld: false)
        }
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20)
        ])
    }
    
    
    private func getUserData(userUid: String?) {
 //       DispatchQueue.global(qos: .background).async {
        guard let userUid = userUid else { return }
        FirebaseManager.shared.getUser(uid: userUid) { user, error in
            print("DEBUG: Getting user data")
            guard let _ = error else {
                self.user = user
                
                return
            }
            self.presentAlertWithOk(message: BOError.internetError.rawValue)
        }
//    }
    }
    
    
    private func getDailyPredictions() {
       // DispatchQueue.global(qos: .background).async {
            FirebaseManager.shared.loadPredictions { predictions, error in
                self.dismissLoadingView()
                print("DEBUG: Getting prediction")
                if let _ = error {
                    self.presentAlertWithOk(message: BOError.internetError.rawValue)
                } else {
                    guard let predictions = predictions else {
                        self.presentAlertWithOk(message: BOError.cantLoadPredictions.rawValue)
                        return
                    }
                    self.predictions = predictions
                }
            }
      //  }

    }
    
    
    private func createAndLoadRewardedAd() -> GADRewardedAd? {
        let rewardedAd = GADRewardedAd(adUnitID: AdmobId.testId)
        rewardedAd.load(GADRequest()) { error in
            if let _ = error {
                self.presentAlertWithOk(message: BOError.internetError.rawValue)
            } else {
                self.headerView.earnCoinButtonStatus(isActive: true)
            }
        }
        return rewardedAd
    }
    
    
}


extension PredictOfDayVC: BOHeaderViewDelegate {
    func didTapRefreshButton() {
        if checkConnection() == false {
            self.presentAlertWithOk(message: BOError.internetError.rawValue)
            return
        }
        showLoadingView()
        headerView.earnCoinButtonStatus(isActive: false)
        rewardedAd = createAndLoadRewardedAd()
        getDailyPredictions()
    }
    
    
    func didTapEarnCoinButton() {
        if checkConnection() &&  rewardedAd?.isReady == true  {
            rewardedAd?.present(fromRootViewController: self, delegate:self)
        } else {
            presentAlertWithOk(message: BOError.cantPresentAd.rawValue)
        }
    }
}


extension PredictOfDayVC: BOPredictionViewDelegate {
    func didTapShowPredictButton() -> Bool {
        if coinCount < 1 {
            self.presentAlertWithOk(message: BOError.haveNotEnoughCoun.rawValue)
            return false
        } else if checkConnection() == false {
            self.presentAlertWithOk(message: BOError.internetError.rawValue)
            return false
        } else {
            self.coinCount -= 1
            let savedUserUid = UserDefaults.standard.string(forKey: "savedUserUid")
            FirebaseManager.shared.updateCoin(uid: savedUserUid, coinCount: coinCount) { (error) in
                if let _ = error {
                    self.coinCount += 1
                    self.presentAlertWithOk(message: BOError.cantUpdateCoinWithDown.rawValue)
                }
            }
            self.headerView.coinUpAndDownAnimation(coinCase: .down)
            return true
        }
    }
    
    
    
}

extension PredictOfDayVC: GADRewardedAdDelegate {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        didEarnCoin = true
        
    }
    
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        headerView.earnCoinButtonStatus(isActive: false)
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        if didEarnCoin {
            self.coinCount += 1
            let savedUserUid = UserDefaults.standard.string(forKey: "savedUserUid")
            FirebaseManager.shared.updateCoin(uid: savedUserUid, coinCount: coinCount) { (error) in
                if let _ = error {
                    self.coinCount -= 1
                    self.presentAlertWithOk(message: BOError.cantUpdateCoinWithUp.rawValue)
                }
            }
            self.headerView.coinUpAndDownAnimation(coinCase: .up)
            didEarnCoin = false
        }
        self.rewardedAd = createAndLoadRewardedAd()
        
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        self.presentAlertWithOk(message: BOError.cantPresentAd.rawValue)
    }
    
    
}
