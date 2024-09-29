//
//  UserService.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 23/09/24.
//

import Foundation
import Firebase
import FirebaseDatabase

struct UserService {
    static func paginateUsers(lastCursor: String?, pageSize: UInt) async throws -> userNode {
        let mainSnapshot : DataSnapshot
        if lastCursor == nil {
            mainSnapshot = try await FirebaseConstants.userRef.queryLimited(toLast: pageSize).getData()
        }else{
            mainSnapshot = try await FirebaseConstants.userRef.queryOrderedByKey().queryEnding(atValue: lastCursor).queryLimited(toLast: pageSize+1).getData()
        }
        guard let first = mainSnapshot.children.allObjects.first as? DataSnapshot,
              let allObjects = mainSnapshot.children.allObjects as? [DataSnapshot] else { return .emptyNode}
        let users : [UserItems] = allObjects.compactMap{userSnapshot in
            let userDict = userSnapshot.value as? [String: Any] ?? [:]
            return UserItems(dictionary: userDict)
        }
        if users.count == mainSnapshot.childrenCount {
            let filteredUsers = lastCursor == nil ? users : users.filter { $0.uid != lastCursor }
            let userNode = userNode(users: filteredUsers, currentCursor: first.key)
            return userNode
        }
        return .emptyNode
    }
    
    static func getUsers(with uids:[String],completion: @escaping (userNode) -> Void){
        var users : [UserItems] = []
        for uid in uids{
            let query = FirebaseConstants.userRef.child(uid)
            query.observeSingleEvent(of: .value) { snapshot in
                guard let user = try? snapshot.data(as: UserItems.self) else {return}
                users.append(user)
                if users.count == uids.count{
                    completion(userNode(users: users))
                }
            } withCancel: { error in
                completion(.emptyNode)
            }
        }
    }
}

struct userNode{
    var users : [UserItems]
    var currentCursor : String?
    static let emptyNode = userNode(users: [], currentCursor: nil)
}
