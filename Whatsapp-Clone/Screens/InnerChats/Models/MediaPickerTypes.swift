//
//  MediaPickerTypes.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 05/10/24.
//

import Foundation
import SwiftUI

struct videoPickerTransferable : Transferable {
    let url : URL
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { exportingFile in
            return .init(exportingFile.url)
        } importing: { receivedFile in
            let originalFile = receivedFile.file
            let uniqueName = "\(UUID().uuidString).mov"
            let copiedFile = URL.documentsDirectory.appendingPathComponent(uniqueName)
            try FileManager.default.copyItem(at: originalFile, to: copiedFile)
            
            return .init(url: copiedFile)
        }
    }
}
