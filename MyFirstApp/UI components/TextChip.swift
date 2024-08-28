//
//  TextChip.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/28/24.
//

import SwiftUI

struct TextChip: View {
    let title: String
    var titleColor: Color? = nil
    var bgColor: Color? = nil
    var padding: CGFloat? = nil
    var cornerRadius: CGFloat? = nil
    var font: Font? = nil

    var body: some View {
        Text(title).padding(padding ?? 6)
            .font(font ?? .headline).background(bgColor ?? .blue).foregroundColor(titleColor ?? .white).cornerRadius(cornerRadius ?? 8)
    }
}

// #Preview {
//    TextChip()
// }
