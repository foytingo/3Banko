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
    //Dummy predictions
    //    var predictions = [Prediction(date: "27 Ekim 2020 16:00", name: "Fenerbahce - Besiktas", organization: "Super Lig", prediction: "2.5 ust", odd: "1.5", isFree: false),
    //                       Prediction(date: "27 Ekim 2020 23:00", name: "Manchester United - Real Madrid", organization: "UEFA Sampiyonlar Ligi", prediction: "2", odd: "2.00", isFree: true),
    //                       Prediction(date: "27 Ekim 2020 23:00", name: "Sivasspor - Villereal", organization: "UEFA Avrupa Ligi", prediction: "3.5 ust", odd: "1.80", isFree: true)]
    
    var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rewardedAd = createAndLoadRewardedAd()
        configureViewController()
        configureHeaderView()
        
        FirebaseManager.shared.loadPredictions { predictions, error in
            guard let predictions = predictions else { return }
            self.predictions = predictions
            print(predictions)
        }
        
        
        
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
        }
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20)
        ])
    }
    
    func createAndLoadRewardedAd() -> GADRewardedAd? {
        let rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/5224354917")
        rewardedAd.load(GADRequest()) { error in
            if let error = error {
                print("Error to load ad: \(error)")
            } else {
                print("Ad load successfully")
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

extension PredictOfDayVC: GADRewardedAdDelegate {
    /// Tells the delegate that the user earned a reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount as Decimal / 10.0).")
        
    }
    /// Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad presented.")
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad dismissed.")
        self.rewardedAd = createAndLoadRewardedAd()
        
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("Rewarded ad failed to present.")
    }
    
    
}
