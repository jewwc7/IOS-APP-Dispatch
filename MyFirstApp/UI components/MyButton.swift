//
//  MyButton.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/8/24.
//

//
//  MyButton.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/8/24.
//

import SwiftUI

struct Frame {
    var height: CGFloat?
    var width: CGFloat?
}

enum ButtonType: String {
    case filled
    case clear
    case outline
}

struct MyButton: View {
    let title: String
    var titleColor: Color? = .white
    var onPress: (() -> Void)?
    var backgroundColor: Color?
    var image: String?
    var frame: Frame?
    var isDisabled: Bool = false
    var isLoading: Bool = false
    var buttonType: ButtonType? = .filled
    var getBackgroundColor: Color {
        if isDisabled == true {
            .gray
        } else {
            backgroundColor ?? .blue
        }
    }

    var body: some View {
        Button(action: {
            //         isLoading = true
            onPress?()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                isLoading = false
//            }
        }) {
            HStack {
                if let image = image {
                    Image(systemName: image)
                }
                Text(title)
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.leading, 8)
                }
            }
        }
        .frame(width: frame?.width, height: frame?.height)
        .padding()
        .background(buttonType == ButtonType.clear ? Color.clear : getBackgroundColor, in: RoundedRectangle(cornerRadius: 8))
        .foregroundColor(titleColor)
        .fixedSize(horizontal: true, vertical: false) // Ensure the button resizes to fit its content
//        .overlay(
//            RoundedRectangle(cornerRadius: 8)
//                .stroke(buttonType == ButtonType.clear ? Color.clear : getBackgroundColor, lineWidth: 1)
//        )
        .disabled(isDisabled || isLoading)
    }

    func onPressDefault() {
        print("Button tapped!")
    }
}

#Preview {
    MyButton(title: "Button", onPress: defaultPress)
}

func defaultPress() {
    print("Button tapped!")
}
