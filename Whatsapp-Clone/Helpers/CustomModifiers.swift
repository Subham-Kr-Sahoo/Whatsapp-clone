//
//  CustomModifiers.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 18/09/24.
//

import Foundation
import SwiftUI

private struct BubbleTailModifier : ViewModifier {
    var direction : messageDirection
    func body(content: Content) -> some View {
        content.overlay(alignment: direction == .received ? .bottomLeading : .bottomTrailing) {
            BubbleTailView(direction: direction)
        }
    }
}

extension View {
    func applyTail(_ direction : messageDirection) -> some View {
        self.modifier(BubbleTailModifier(direction: direction))
    }
}
