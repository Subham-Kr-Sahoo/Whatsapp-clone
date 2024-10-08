//
//  UIApplication + Extension.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 08/10/24.
//

import UIKit

extension UIApplication {
    static func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
