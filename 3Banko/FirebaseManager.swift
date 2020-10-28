//
//  FirebaseManager.swift
//  3Banko
//
//  Created by Murat Baykor on 28.10.2020.
//

import Firebase

struct FirebaseManager {
    
    static let shared = FirebaseManager()
    
    let db = Firestore.firestore()
    
    func loadPredictions(completion: @escaping ([String: Any]?, Error?) -> Void) {
        var predicts: [String: Any]?
        
        db.collection("predicts").order(by: "id", descending: true).limit(to: 1).getDocuments { snapshot, error in
            if let error = error {
                completion(predicts, error)
            } else {
                for document in snapshot!.documents {
                    predicts = document.data()
                }
                completion(predicts,error)
            }
        }
    }
    
    func authAnonymous(completion: @escaping(String, Error?) -> Void) {
        var uid = ""
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                completion(uid, error)
            } else {
                guard let user = authResult?.user else { return }
                uid = user.uid
                completion(uid,error)
            }
        }
    }
    
    func firstLaunchOptions(completion: @escaping(Error?)-> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                completion(error)
            } else {
                guard let user = authResult?.user else { return }
                db.collection("Users").document(user.uid).setData(["userUid" : user.uid, "coinCount" : 0, "isPaidUser": false])
            }
        }
    }
    
    func getUser(uid: String, completion: @escaping(BOUser?,Error?) -> Void) {
        db.collection("Users").document(uid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(nil,error)
            } else {
                guard let data = snapshot?.data() else { return }
                let uid = data["userUid"] as! String
                let coinCount = data["coinCount"] as! Int
                let isPaidUser = data["isPaidUser"] as! Bool
                
                let user = BOUser(uid: uid, coinCount: coinCount, isPaidUser: isPaidUser)
                completion(user,error)
            }
            
        }
        
    }
    

}
