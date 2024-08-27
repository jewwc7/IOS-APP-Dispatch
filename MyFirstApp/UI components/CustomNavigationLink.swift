//
//  CustomNavigationLink.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/31/24.
//

import SwiftUI

struct CustomNavigationLink<Destination: View>: View {
    let destination: Destination
    let title: String
    var bgColor: Color? = .gray
    var textColor: Color? = .white
    var onTapGesture: (() -> Void)? = nil

    //  let label: () -> Label  //label not in use right now
    @State private var isActive: Bool = false
    // @Binding var config: ICustomNavigationLinkConfig
//    let config = ICustomNavigationLink(title: "PlaceHolder") {
//        print("Hello")
//    }

    var body: some View {
        NavigationStack {
            NavigationLink(title) {
                destination
            }.simultaneousGesture(TapGesture().onEnded {
                if let onTapGesture {
                    onTapGesture()
                }
            })
//                .background(bgColor)
//                .foregroundColor(textColor)
//                .cornerRadius(10)
//            Button(action: {
//                self.isActive = true
//                print("hey")
//            }) {
//                label()
//            }
        }
    }

    func noTapGestureProvided() {
        print("No tap gesture provided to custom navigation link")
    }
}

#Preview {
    CustomNavigationLink(destination: CustomerList(), title: "PlaceHolderPreview") {
        print("preview tapped")
    }
}
