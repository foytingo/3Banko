//
//  Constants.swift
//  3Banko
//
//  Created by Murat Baykor on 30.10.2020.
//

import UIKit

enum Color {
    static let BOGreen = UIColor(red: 0.03, green: 0.46, blue: 0.44, alpha: 1.00)
    static let BORed: UIColor = UIColor(red: 0.73, green: 0.13, blue: 0.02, alpha: 1.00)
}

enum AdmobId {
    static let testId = "ca-app-pub-3940256099942544/5224354917"
    static let addID = "ca-app-pub-1024628359947334/7259979125"
}

enum ScreenSize {
    static let width                    = UIScreen.main.bounds.size.width
    static let height                   = UIScreen.main.bounds.size.height
    static let maxLength                = max(ScreenSize.width, ScreenSize.height)
    static let minLength                = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale

    static let isiPhone12mini           = idiom == .phone && ScreenSize.maxLength == 780.0
    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8orSE2Standard   = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8orSE2Zoomed     = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0

    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}
