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
    
//    func createUserCollection(user: BOUser, completion: @escaping(Error?)-> Void) {
//        
//        db.collection("Users").addDocument(data: ["userUid" : user.uid, "coinCount" : user.coinCount], completion: completion)
//
//      
//    }
}
