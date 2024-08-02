//
//  MyChip.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/2/24.
//

import SwiftUI

struct MyChip: View {
    var text: String
    var backgroundColor: Color? = .blue
    var textColor: Color? = .white

    var body: some View {
        Text(text)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(16)
    }
}

#Preview {
    MyChip(text:"Chip")
}
