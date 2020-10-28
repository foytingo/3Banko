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
        
//        db.collection("predicts").document("Day1").getDocument { snapshot, error in
//            if let error = error {
//                completion(predicts, error)
//            } else {
//                guard let snapshot = snapshot else {
//                    completion(predicts,error)
//                    return
//                }
//                predicts = snapshot.data()
//                completion(predicts,error)
//            }
//        }
        
//        db.collection("predicts").getDocuments { snapshot, error in
//            if let error = error {
//                completion(predicts, error)
//            } else {
//                snapshot?.documents[0].data()
//
//                for document in snapshot!.documents {
//                    let date = document.data()["date"] as! Double
//                    let name = document.data()["name"] as! String
//                    let organization = document.data()["organization"] as! String
//                    let prediction = document.data()["prediction"] as! String
//                    let odd = document.data()["odd"] as! String
//                    let isFree = document.data()["isFree"] as! Bool
//
//                    let predict = Prediction(date: String(date), name: name, organization: organization, prediction: prediction, odd: odd, isFree: isFree)
//
//                    predicts.append(predict)
//                }
//            }
//
//        }
        
    }
    
}
