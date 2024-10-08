//
//  UIWindowScene + Extension.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 08/10/24.
//

import UIKit

extension UIWindowScene {
    static var current : UIWindowScene? {
        return UIApplication.shared.connectedScenes.first {$0 is UIWindowScene} as? UIWindowScene
    }
    
    var screenHeight : CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var screenWidth : CGFloat {
        return UIScreen.main.bounds.width
    }
}
