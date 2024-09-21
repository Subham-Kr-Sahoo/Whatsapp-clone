//
//  FirebaseConstants.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 21/09/24.
//

import Foundation
import Firebase
import FirebaseStorage

enum FirebaseConstants {
    private static let DatabaseRef = Database.database().reference()
    static let userRef = DatabaseRef.child("users")
}
