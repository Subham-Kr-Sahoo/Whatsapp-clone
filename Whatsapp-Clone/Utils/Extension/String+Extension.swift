//
//  String+Extension.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 27/09/24.
//

import Foundation
import UIKit

extension String {
    var isEmptyOrWhiteSpace: Bool {return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty}
    
    func numberOfLines(font: UIFont = .systemFont(ofSize: 17), width: CGFloat = UIScreen.main.bounds.width - 32) -> Int {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let estimatedRect = (self as NSString).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font], context: nil)
        return Int(estimatedRect.height / font.lineHeight)
    }
}
