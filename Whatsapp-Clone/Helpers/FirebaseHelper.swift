//
//  FirebaseHelper.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 08/10/24.
//

import Foundation
import UIKit
import FirebaseStorage

typealias uploadCompletion = (Result<URL,Error>) -> Void
typealias ProgressHandler = (Double) -> Void

enum uploadError : Error {
    case failedToUploadImage(_ description : String)
    case failedToUploadFile(_ description : String)
}

extension uploadError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToUploadImage(let description):
            return description
        case .failedToUploadFile(let description):
            return description
        }
    }
}

struct FirebaseHelper {
    static func uploadImage(_ image: UIImage, for type: uploadType, completion: @escaping uploadCompletion, progressHandler: @escaping ProgressHandler){
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
        let storageRef = type.filepath
        let uploadTask = storageRef.putData(imageData){ _ , error in
            if let error = error {
                print("failed to upload an image to the storage")
                completion(.failure(uploadError.failedToUploadImage(error.localizedDescription)))
                return
            }
            storageRef.downloadURL(completion: completion)
        }
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else {return}
            let percentage = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
            progressHandler(percentage)
        }
    }
    // responsible for uploading both video & audio , i can make it to upload some documents
    static func uploadfile(for type: uploadType, fileURL: URL, completion: @escaping uploadCompletion, progressHandler: @escaping ProgressHandler){
        let storageRef = type.filepath
        let uploadTask = storageRef.putFile(from: fileURL){ _ , error in
            if let error = error {
                print("failed to upload a file to the storage")
                completion(.failure(uploadError.failedToUploadFile(error.localizedDescription)))
                return
            }
            storageRef.downloadURL(completion: completion)
        }
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else {return}
            let percentage = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
            progressHandler(percentage)
        }
    }
}

extension FirebaseHelper {
    enum uploadType {
        case profile
        case photoMessage
        case videoMessage
        case audioMessage
        
        var filepath: StorageReference {
            let fileName = UUID().uuidString
            switch self {
            case .profile:
                // path -> storage > profile_image_urls > fileName
                return FirebaseConstants.storageRef.child("profile_image_urls").child(fileName)
            case .photoMessage:
                return FirebaseConstants.storageRef.child("photo_message").child(fileName)
            case .videoMessage:
                return FirebaseConstants.storageRef.child("video_message").child(fileName)
            case .audioMessage:
                return FirebaseConstants.storageRef.child("audio_message").child(fileName)
            }
        }
    }
}
