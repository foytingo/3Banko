//
//  BOError.swift
//  3Banko
//
//  Created by Murat Baykor on 30.10.2020.
//

import Foundation

enum BOError: String, Error {
    case cantLoadPredictions = "Günün tahminleri yüklenemedi.\nInternet baglantinizi kontrol ettikten sonra tekrar deneyin."
    case cantLoadAllPredictions = "Eski tahminler yüklenemedi.\nInternet baglantinizi kontrol ettikten sonra tekrar deneyin."
    case cantAuthAnonymously = "Giris yapılamadı."
    case cantPerformFirtsLaunchOptions = "İlk giriş ayarları yapılamadı."
    case cantGetUser = "Jeton bilgisi alınamadı\nInternet baglantinizi kontrol ettikten sonra tekrar deneyin.."
    case cantUpdateCoinWithDown = "Jeton bilgisi güncellenemedi.\nJetonunuz iade edildi."
    case cantUpdateCoinWithUp = "Jeton bilgisi güncellenemedi.\nJetonunuz ger alindi."
    case haveNotEnoughCoun = "Yeterli jetonunuz yok.\nJeton kazan butonuyla reklam izleyerek jeton kazanabilirsiniz."
    case cantPresentAd = "Reklam gosterilemedi.\nInternet baglantinizi kontrol ettikten sonra tekrar deneyin."
    case internetError = "Sunucuyla baglanti kurulamadi.\nInternet baglantinizi kontrol ettikten sonra sayfayi yenileyiniz."
}
