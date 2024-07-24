//
//  MyButton.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/8/24.
//

import SwiftUI

struct Frame {
    var height:CGFloat?
    var width:CGFloat?
}

struct MyButton: View {
    let title: String
    var onPress: (() -> Void)? //how to make this an optional property, the  ? at the end does not work
    var backgroundColor: Color? // If it’s set to let then it has to be set at init. And can’t be changed. Let us for constants, var is for
    var image: String?
    var titleColor: Color?
    var frame:Frame?
    
    var body: some View {
        
        
        Button(title, systemImage: image ?? "xmark", action: onPress ?? onPressDefault).frame(width: frame?.width ?? 200, height: frame?.height ?? 300).padding().background(backgroundColor ?? .black, in: RoundedRectangle(cornerRadius: 8)).foregroundColor(.white)
    }
    
    func onPressDefault() {
        print("Button tapped!")
    }
}


#Preview {
    MyButton(title: "Button", onPress: defaultPress)
    
}

func defaultPress(){
    print("Button tapped!")
}
