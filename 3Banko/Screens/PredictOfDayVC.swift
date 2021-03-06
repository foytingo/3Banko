//
//  PredictOfDayVC.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit
import GoogleMobileAds
import Network
import AppTrackingTransparency

class PredictOfDayVC: BODataLoadingViewController {
    
    let monitor = NWPathMonitor()
    
    let headerView = BOHeaderView(frame: .zero)
    
    let stackView = UIStackView()
    let predictOne = BOPredictionView(frame: .zero)
    let predictTwo = BOPredictionView(frame: .zero)
    let predictThree = BOPredictionView(frame: .zero)
    
    var errorCountAd = 0
    var didEarnCoin = false
    
    var rewardedAd: GADRewardedAd?
    
    var predictions: [String: Any]? {
        didSet {
            
            configurePredictViews()
            
        }
    }
    
    var userUid: String? {
        didSet {
            
            let launcedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
            
            
            if launcedBefore == false {
                FirebaseManager.shared.firstLaunchOption(with: userUid!) { error in
                    if error != nil {
                        self.presentAlertWithOk(message: BOError.cantPerformFirtsLaunchOptions.rawValue)
                    } else {
                        UserDefaults.standard.set(true, forKey: "launchedBefore")
                        UserDefaults.standard.set(self.userUid!, forKey: "savedUserUid")
                        self.getUserData(userUid: self.userUid!)
                        self.getDailyPredictions()
                    }
                }
            } else {
                
                let savedUserUid = UserDefaults.standard.string(forKey: "savedUserUid")
                getUserData(userUid: savedUserUid)
                
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        
        showLoadingView()
        //requestIDFA()
        authProcess()
        configureViewController()
        rewardedAd = createAndLoadRewardedAd()
    }
    
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                self.rewardedAd = self.createAndLoadRewardedAd()
            }
        } else {
            rewardedAd = createAndLoadRewardedAd()
        }
    }
    
    
    func checkConnection() -> Bool {
        return monitor.currentPath.status == .unsatisfied ? false : true
    }
    
    
    func authProcess() {
        DispatchQueue.global(qos: .userInitiated).async {
            if FirebaseManager.shared.getSingedUserUid() != nil {
                FirebaseManager.shared.signOut { (error) in
                    if error != nil {
                        self.presentAlertWithOk(message: BOError.cantAuthAnonymously.rawValue)
                    }
                }
            }
            
            FirebaseManager.shared.authAnonymous { userUid, error in
                if error != nil {
                    self.presentAlertWithOk(message: BOError.cantAuthAnonymously.rawValue)
                } else {
                    //print("DEBUG: UserUid: \(userUid ?? "This should be user uid")")
                    self.userUid = userUid
                    
                }
            }
            
        }
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
        guard let userUid = userUid else { return }
        FirebaseManager.shared.getUser(uid: userUid) { user, error in
            guard error != nil else {
                self.user = user
                
                return
            }
            //print("DEBUG: error in getUserData: \(error)")
            self.presentAlertWithOk(message: BOError.cantGetUser.rawValue)
        }
    }
    
    
    private func getDailyPredictions() {
        DispatchQueue.global(qos: .userInitiated).async {
            FirebaseManager.shared.loadPredictions { predictions, error in
                self.dismissLoadingView()
                if error != nil {
                    //print("DEBUG: error in getDailyPrediction: \(error)")
                    self.presentAlertWithOk(message: BOError.cantLoadPredictions.rawValue)
                } else {
                    guard let predictions = predictions else {
                        self.presentAlertWithOk(message: BOError.cantLoadPredictions.rawValue)
                        return
                    }
                    self.predictions = predictions
                }
            }
        }
    }
    
    
    private func createAndLoadRewardedAd() -> GADRewardedAd? {
        let rewardedAd = GADRewardedAd(adUnitID: AdmobId.addID)
        DispatchQueue.global(qos: .userInitiated).async {

            rewardedAd.load(GADRequest()) { error in
                guard error != nil else {
                    self.headerView.earnCoinButtonStatus(isActive: true)
                    return
                }
                
                self.errorCountAd += 1
            }
        }
        return rewardedAd
    }
    
    
}


extension PredictOfDayVC: BOHeaderViewDelegate {
    func didTapRefreshButton() {
        if checkConnection() == false {
            //print("DEBUG: error in connection")
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

            if errorCountAd == 1 || errorCountAd % 10 == 0 {
                presentAlertWithOkAndTitle(title: BOError.cantPresentAdTitle.rawValue, message: BOError.cantPresentAdFirstError.rawValue)
                self.coinCount += 1
                let savedUserUid = UserDefaults.standard.string(forKey: "savedUserUid")
                FirebaseManager.shared.updateCoin(uid: savedUserUid, coinCount: coinCount) { (error) in
                    if let _ = error {
                        self.coinCount -= 1
                        self.presentAlertWithOk(message: BOError.cantUpdateCoinWithUp.rawValue)
                    }
                }
                self.headerView.coinUpAndDownAnimation(coinCase: .up)
            } else {
                presentAlertWithOkAndTitle(title: BOError.cantPresentAdTitle.rawValue, message: BOError.cantPresentAd.rawValue)
            }
            
            rewardedAd = createAndLoadRewardedAd()

        }
    }
}


extension PredictOfDayVC: BOPredictionViewDelegate {
    func didTapShowPredictButton() -> Bool {
        if coinCount < 1 {
            self.presentAlertWithOk(message: BOError.haveNotEnoughCoun.rawValue)
            return false
        } else if checkConnection() == false {
            //print("DEBUG: error in connection")
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
