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
        if lastCursor == nil {
            //initial data fetch from bottom of the table
            let mainSnapshot = try await FirebaseConstants.userRef.queryLimited(toLast: pageSize).getData()
            guard let first = mainSnapshot.children.allObjects.first as? DataSnapshot,
                  let allObjects = mainSnapshot.children.allObjects as? [DataSnapshot] else { return .emptyNode}
            let users : [UserItems] = allObjects.compactMap{userSnapshot in
                let userDict = userSnapshot.value as? [String: Any] ?? [:]
                return UserItems(dictionary: userDict)
            }
            if users.count == mainSnapshot.childrenCount {
                let userNode = userNode(users: users, currentCursor: first.key)
                return userNode
            }
            return .emptyNode
        }else{
            // paginate more data until the page runs out of data
            let mainSnapshot = try await FirebaseConstants.userRef.queryOrderedByKey().queryEnding(atValue: lastCursor).queryLimited(toLast: pageSize+1).getData()
            guard let first = mainSnapshot.children.allObjects.first as? DataSnapshot,
                  let allObjects = mainSnapshot.children.allObjects as? [DataSnapshot] else { return .emptyNode}
            let users : [UserItems] = allObjects.compactMap{userSnapshot in
                let userDict = userSnapshot.value as? [String: Any] ?? [:]
                return UserItems(dictionary: userDict)
            }
            if users.count == mainSnapshot.childrenCount {
                let filteredUsers = users.filter { $0.uid != lastCursor }
                let userNode = userNode(users: filteredUsers, currentCursor: first.key)
                return userNode
            }
            return .emptyNode
        }
    }
}

struct userNode{
    var users : [UserItems]
    var currentCursor : String?
    static let emptyNode = userNode(users: [], currentCursor: nil)
}
