//
//  FirstPage.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/24/24.
//

import SwiftData
import SwiftUI

struct FirstPage: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack {
            HStack {
                Button("Create seed") {
                    createSeeds(modelContext: context)
                }
            }
            
            HStack {
                // the order od modifieres matters
                NavigationLink(destination: CustomerListView()) {
                    Text("Customer")
                }.frame(width: buttonFrame.width, height: buttonFrame.height).padding().background(.blue, in: RoundedRectangle(cornerRadius: 8)).foregroundColor(.white)
                
                //                    MyButton(title: "Press Me", onPress: goToCustomer)
                
                Spacer()
                
                NavigationLink(destination: DriverList()) {
                    Text("Driver")
                }.frame(width: buttonFrame.width, height: buttonFrame.height).padding().background(.blue, in: RoundedRectangle(cornerRadius: 8)).foregroundColor(.white)
                
            }.frame(width: 180)
        }
    }
}
