//
//  DataManager.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/14.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class DataManager {
    static let shared = DataManager()
    
    let database = Database.database().reference()
    let storage = Storage.storage().reference()
    
    var latestposts = [Post]()
    var loadedPosts = [Post]()
   
    
    private let numberOfOneLoad = 5
    
    public func uploadUserImage(userImage: UIImage, email: String, completion: @escaping (Bool)->Void) {
        let imageRef = storage.child(email.safetyDatabaseString() + ".jpg")
        guard let uploadData = userImage.jpegData(compressionQuality: 0.9) else {
            print("ConvertImageToData Error")
            return
        }
        let metaData = StorageMetadata()
        metaData.contentType = "jpeg"
        imageRef.putData(uploadData, metadata: metaData) {
            metadata, error in
            if let error = error {
                print("Upload Error : \(error.localizedDescription)")
            } else {
                completion(true)
            }
        }
    }
    
    public func downloadUserImage(email: String, completion: @escaping (URL?)->Void) {
        let imageRef = storage.child(email.safetyDatabaseString() + ".jpg")
        imageRef.downloadURL { (url, error) in
            if let error = error {
                print("Download Error : \(error.localizedDescription)")
            } else {
                print("다운로드 성공")
                completion(url)
            }
        }
    }
    
    //MARK: - download & upload Posts
    
    public func loadPosts(completion: @escaping (Bool)->Void) {
        var orderedQuery: DatabaseQuery?
        orderedQuery = database.child("posts").queryOrdered(byChild: "endDate")
        orderedQuery?.observeSingleEvent(of: .value, with: { snapshot in
            var snapshotData = snapshot.children.allObjects
            snapshotData.reverse()
            
            for anyDatum in snapshotData {
                let snapshotDatum = anyDatum as! DataSnapshot
//                let postkey = snapshotDatum.key
                let dicDatum = snapshotDatum.value as! [String:Any]
                let post = Post(dictionary: dicDatum)
                
                if let firstCardID = dicDatum["firstCardID"] as? String {
                    post.firstCard = CardManager.shared.searchCardByID(cardID: firstCardID)
                }
                if let secondCardID = dicDatum["secondCardID"] as? String {
                    post.secondCard = CardManager.shared.searchCardByID(cardID: secondCardID)
                }
                if let thirdCardID = dicDatum["thirdCardID"] as? String {
                    post.thirdCard = CardManager.shared.searchCardByID(cardID: thirdCardID)
                }
                
                self.loadedPosts += [post]
            }
            self.latestposts += self.loadedPosts.prefix(self.numberOfOneLoad)
            
            // loadedPosts에서 포스트의 카드마다 내 현재 감정(내 글의 카드 타입 평균치 -> cardType)과 비슷한 감정의 글을 모아서 넣어주기
            // 이건 다 가져와서, 내부적으로 쿼리를 해야겠다.
            // self.sympathyPosts
            
            // loadedPosts에서 UserCount가 가장 많은 
            
            completion(true)
        })
    }
    
    public func loadFreshPosts(completion: @escaping (Bool)->Void) {
        var filterQuery: DatabaseQuery?
        
        if let latestDate = self.latestposts.first?.endDate {
            filterQuery = database.child("posts").queryOrdered(byChild: "endDate").queryStarting(afterValue: latestDate)
        } else {
            filterQuery = database.child("posts").queryOrdered(byChild: "endDate").queryStarting(atValue: 0)
        }
        
        filterQuery?.observeSingleEvent(of: .value, with: { snapshot in
            var snapshotData = snapshot.children.allObjects
            snapshotData.reverse()
            
            var freshPostsChunk = [Post]()
            
            for anyDatum in snapshotData {
                let snapshotDatum = anyDatum as! DataSnapshot
//                let postkey = snapshotDatum.key
                let dicDatum = snapshotDatum.value as! [String:Any]
                let post = Post(dictionary: dicDatum)
                
                if let firstCardID = dicDatum["firstCardID"] as? String {
                    post.firstCard = CardManager.shared.searchCardByID(cardID: firstCardID)
                }
                if let secondCardID = dicDatum["secondCardID"] as? String {
                    post.secondCard = CardManager.shared.searchCardByID(cardID: secondCardID)
                }
                if let thirdCardID = dicDatum["thirdCardID"] as? String {
                    post.thirdCard = CardManager.shared.searchCardByID(cardID: thirdCardID)
                }
                
                freshPostsChunk += [post]
            }
            self.loadedPosts.insert(contentsOf: freshPostsChunk, at: 0)
            self.latestposts.insert(contentsOf: freshPostsChunk, at: 0)
            completion(true)
        })
    }
    
    public func loadPastPosts(completion: @escaping (Bool)->Void){
        let pastPosts = self.loadedPosts.filter { $0.endDate < (self.latestposts.last?.endDate)! }
        let pastChunkPosts = pastPosts.prefix(numberOfOneLoad)
        
        if pastChunkPosts.count > 0 {
            self.latestposts += pastChunkPosts
            completion(true)
        }
    }
}
