//
//  FirebaseConstants.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 21/09/24.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

enum FirebaseConstants {
    private static let DatabaseRef = Database.database().reference()
    static let userRef = DatabaseRef.child("users")
    static let channelsRef = DatabaseRef.child("channels")
    static let messagesRef = DatabaseRef.child("channel-messages")
    static let userChannelsRef = DatabaseRef.child("user-channels")
    static let userDirectChannels = DatabaseRef.child("user-direct-channels")
    
    static let storageRef = Storage.storage().reference()
}
