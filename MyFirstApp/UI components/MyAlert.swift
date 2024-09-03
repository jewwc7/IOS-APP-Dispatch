//
//  MyAlert.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 9/3/24.
//

import SwiftUI

struct MyAlert: View {
    @Binding var isPresented: Bool
    var title: String
    var message: String
    var onYes: () -> Void
    var onNo: () -> Void

    var body: some View {
        if isPresented {
            VStack {
                Text(title)
                    .font(.headline)
                    .padding()
                Text(message)
                    .font(.subheadline)
                    .padding()
                HStack {
                    Button(action: {
                        onYes()
                        //  isPresented = false
                    }) {
                        Text("Yes")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    Button(action: {
                        onNo()
                        // isPresented = false
                    }) {
                        Text("No")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .frame(width: 300, height: 200)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .transition(.scale)
        }
    }
}

//
// #Preview {
//    MyAlert(isPresented: true, title: "hello", message: "would you like to come with me?") {
//        print("Yes pressed")
//    } onNo: {
//        print("No pressed")
//    }
//
////    ModelPreview { order in
////        MyAlert(isPresented: true, title: "hello", message: "would you like to come with me?") {
////            print("Yes pressed")
////        } onNo: {
////            print("No pressed")
////        }
////    }
// }
