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
    static let placeholder = UserItems(uid: "1", username: "New Contact from phone", email: "subhamkrsahoo@gmail.com",bio: "Hey there! I am using WhatsApp")
    
    static let placeholders: [UserItems] = [
        UserItems(uid: "1", username: "Subham", email: "subhamkrsahoo@example.com", bio: "Hey there! I am using WhatsApp"),
        UserItems(uid: "2", username: "John", email: "johndoe@example.com", bio: "Exploring the world, one step at a time."),
        UserItems(uid: "3", username: "Jane", email: "janesmith@example.com", bio: "Coffee addict and tech enthusiast."),
        UserItems(uid: "4", username: "Mike", email: "mikeross@example.com", bio: "Lover of books and legal drama."),
        UserItems(uid: "5", username: "Emma", email: "emmawatson@example.com", bio: "Living life in the fast lane."),
        UserItems(uid: "6", username: "James", email: "jamesbrown@example.com", bio: "Music is life!"),
        UserItems(uid: "7", username: "Sarah", email: "sarahjohnson@example.com", bio: "Nature lover and wildlife photographer."),
        UserItems(uid: "8", username: "David", email: "davidbeckham@example.com", bio: "Football is passion."),
        UserItems(uid: "9", username: "Sophia", email: "sophiamiller@example.com", bio: "Art is my therapy."),
        UserItems(uid: "10", username: "Chris", email: "chrisevans@example.com", bio: "Captain America IRL."),
        UserItems(uid: "11", username: "Olivia", email: "oliviabrown@example.com", bio: "Designer, dreamer, doer."),
        UserItems(uid: "12", username: "Liam", email: "liamwilson@example.com", bio: "Travel, food, repeat."),
        UserItems(uid: "13", username: "Ava", email: "avadavis@example.com", bio: "Coding my way through life."),
        UserItems(uid: "14", username: "Noah", email: "noahmoore@example.com", bio: "Film geek and movie buff."),
        UserItems(uid: "15", username: "Mia", email: "miataylor@example.com", bio: "Adventure seeker and outdoor enthusiast.")
    ]
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
