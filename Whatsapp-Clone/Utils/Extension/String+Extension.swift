//
//  String+Extension.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 27/09/24.
//

import Foundation

extension String {
    var isEmptyOrWhiteSpace: Bool {return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty}
}
