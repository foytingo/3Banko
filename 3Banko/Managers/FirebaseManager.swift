//
//  FirebaseManager.swift
//  3Banko
//
//  Created by Murat Baykor on 28.10.2020.
//

import Firebase
import FirebaseAuth

struct FirebaseManager {
    
    static let shared = FirebaseManager()
    
    let db = Firestore.firestore()
    
    func signOut(completion: @escaping(Error?)-> Void) {
        do {
            try Auth.auth().signOut()
        } catch {
            completion(error)
        }
        completion(nil)
        
    }
    
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
    
    
    func getAllPredictions(day: Int, completion: @escaping ([[String: Any]], Error?) -> Void) {
        var allPredictsArray = [[String: Any]]()
        
        db.collection("predicts").order(by: "id", descending: true).limit(to: day).getDocuments { snapshot, error in
            if let error = error {
                completion(allPredictsArray, error)
            } else {
                for document in snapshot!.documents {
                    allPredictsArray.append(document.data())
                }
                allPredictsArray.remove(at: 0)

                completion(allPredictsArray,error)
            }
        }
    }
    
    
    func authAnonymous(completion: @escaping(String? , Error?) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                completion(nil,error)
            } else {
                completion(authResult?.user.uid, error)
            }
        }
    }
    
    
    func getSingedUserUid() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func deleteCurrentUser(completion: @escaping(Error?)-> Void) {
        Auth.auth().currentUser?.delete(completion: completion)
    }
    
    
    func firstLaunchOption(with userUid: String, completion: @escaping(Error?)-> Void) {
        db.collection("Users").document(userUid).setData(["userUid" : userUid, "coinCount" : 3, "isPaidUser": false], completion: completion)
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
    
    
    func updateCoin(uid: String?, coinCount: Int, completion: @escaping(Error?) -> Void) {
        guard let uid = uid else { return }
        
        db.collection("Users").document(uid).updateData(["coinCount": coinCount]) { error in
            if let error = error {
                completion(error)
            } else {
              completion(nil)
            }
        }
    }
    
    

}
