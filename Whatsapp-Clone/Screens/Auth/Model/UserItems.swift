//
//  UserItems.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 21/09/24.
//

import Foundation

struct UserItems : Identifiable,Hashable,Decodable {
    let uid : String
    let username : String
    let email : String
    var bio : String? = nil
    var profileImageUrl : String? = nil
    var id : String {
        return uid
    }
    var bioUnwrapped : String {
        return bio ?? "Hey there! I am using WhatsApp"
    }
    static let placeholder = UserItems(uid: "1", username: "Subham", email: "subhamkrsahoo@gmail.com")
}

extension UserItems {
    init(dictionary:[String:Any]){
        self.uid = dictionary[.uid] as? String ?? ""
        self.username = dictionary[.username] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.bio = dictionary[.bio] as? String ?? nil
        self.profileImageUrl = dictionary[.profileImageUrl] as? String ?? nil
    }
}

extension String {
    static let uid = "uid"
    static let username = "username"
    static let email = "email"
    static let bio = "bio"
    static let profileImageUrl = "profileImageUrl"
}
