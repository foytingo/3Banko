//
//  PredictOfDayVC.swift
//  3Banko
//
//  Created by Murat Baykor on 27.10.2020.
//

import UIKit
import GoogleMobileAds

class PredictOfDayVC: UIViewController {
    
    let headerView = BOHeaderView(frame: .zero)
    
    let stackView = UIStackView()
    let predictOne = BOPredictionView(frame: .zero)
    let predictTwo = BOPredictionView(frame: .zero)
    let predictThree = BOPredictionView(frame: .zero)
    
    
    
    var predictions: [String: Any]? {
        didSet {
            let predictionViewArray = [predictOne, predictTwo, predictThree]
            for (index, predictView) in predictionViewArray.enumerated() {
                predictView.set(predict: predictions!["predict\(index + 1)"] as! [String : Any])
            }
            configurePredictViews()
        }
    }

    var rewardedAd: GADRewardedAd?
    var userUid: String? {
        didSet {
            guard let userUid = userUid else { return}
            FirebaseManager.shared.getUser(uid: userUid) { user, error in
                self.user = user
            }
        }
    }
    var coinCount: Int = 0 {
        didSet {
            headerView.set(coinCount: coinCount)
        }
    }
    var user: BOUser? {
        didSet {
            guard let user = user else { return }
            self.coinCount = user.coinCount
            let predictionViewArray = [predictOne, predictTwo, predictThree]
            for predictionView in predictionViewArray {
                predictionView.set(user: user)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anonymousLogin()
        
        
        configureViewController()
        configureHeaderView()
        
        FirebaseManager.shared.loadPredictions { predictions, error in
            guard let predictions = predictions else { return }
            self.predictions = predictions
        }
        rewardedAd = createAndLoadRewardedAd()
    }
    
    private func configureViewController() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.03, green: 0.46, blue: 0.44, alpha: 1.00)]
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
        for predictView in predictionViewArray {
            stackView.addArrangedSubview(predictView)
            predictView.predictViewDelegate = self
        }
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20)
        ])
    }
    
    func anonymousLogin() {
        FirebaseManager.shared.authAnonymous { (uid, error) in
            guard let error = error else {
                self.userUid = uid
                return
            }
            print("DEBUG: Error: \(error)")
        }
    }
    
    func createAndLoadRewardedAd() -> GADRewardedAd? {
        let rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/5224354917")
        rewardedAd.load(GADRequest()) { error in
            if let error = error {
                print("DEBUG: Error to load ad: \(error)")
            } else {
                print("DEBUG: Ad load successfully")
            }
        }
        return rewardedAd
    }
    
    
    
}

extension PredictOfDayVC: BOHeaderViewDelegate {
    func didTapEarnCoinButton() {
        
        if rewardedAd?.isReady == true {
            rewardedAd?.present(fromRootViewController: self, delegate:self)
        }
    }
    
}

extension PredictOfDayVC: BOPredictionViewDelegate {
    func didTapShowPredictButton() -> Bool {
        if coinCount < 1 {
            return false
        } else {
            self.coinCount -= 1
            FirebaseManager.shared.updateCoin(uid: userUid!, coinCount: coinCount) { (error) in
                if let error = error {
                    print("DEBUG: \(error)")
                } else {
                    print("DEBUG: Coin successfully removed")
                    print("DEBUG: Show coin remove animation")
                }
            }

            return true
        }
    }

    
    
}

extension PredictOfDayVC: GADRewardedAdDelegate {
    /// Tells the delegate that the user earned a reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        self.coinCount += 1
        FirebaseManager.shared.updateCoin(uid: userUid!, coinCount: coinCount) { (error) in
            if let error = error {
                print("DEBUG: \(error)")
            } else {
                print("DEBUG: Coin successfully added")
            }
        }
    }
    /// Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("DEBUG: Rewarded ad presented.")
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("DEBUG: Rewarded ad dismissed.")
        self.rewardedAd = createAndLoadRewardedAd()
        print("DEBUG: Show coin add animation")
        
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("DEBUG: Rewarded ad failed to present.")
    }
    
    
}
