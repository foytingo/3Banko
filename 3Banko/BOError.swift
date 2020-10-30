//
//  BOError.swift
//  3Banko
//
//  Created by Murat Baykor on 30.10.2020.
//

import Foundation

enum BOError: String, Error {
    case cantLoadPredictions = "Günün tahminleri yüklenemedi."
    case cantLoadAllPredictions = "Eski tahminler yüklenemedi."
    case cantAuthAnonymously = "Giris yapılamadı."
    case cantPerformFirtsLaunchOptions = "İlk giriş ayarları yapılamadı."
    case cantGetUser = "Jeton bilgisi alınamadı."
    case cantUpdateCoin = "Jeton bilgisi güncellenemedi."
}
