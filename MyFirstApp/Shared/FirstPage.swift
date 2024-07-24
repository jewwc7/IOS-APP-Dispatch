//
//  FirstPage.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/24/24.
//

import SwiftUI
import SwiftData

struct FirstPage: View {
   // @Query private var appState: AppModel
   @Environment(\.modelContext) private var context //how to CRUD state
   
    
    let buttonFrame = (Frame(height: 40, width:100))
    
    var body: some View {

            VStack {
                HStack {
                    // the order od modifieres matters
                    NavigationLink(destination: CustomerMainScreen()) {
                        Text("Customer")
                    }.frame(width: buttonFrame.width, height: buttonFrame.height).padding().background(.blue, in: RoundedRectangle(cornerRadius: 8)).foregroundColor(.white)
                    
//                    MyButton(title: "Press Me", onPress: goToCustomer)
                    
                    Spacer()
                    
                    NavigationLink(destination: AvailableOrderScreen()) {
                        Text("Driver")
                    }.frame(width: buttonFrame.width, height: buttonFrame.height).padding().background(.blue, in: RoundedRectangle(cornerRadius: 8)).foregroundColor(.white)
                    
                    
                }.frame(width: 180)
                
            }
        }
    
    func goToCustomer(){
            print("Going to customer page")
    //    appState.path = AppRoute.screenTwo
        do {
            try context.save()
        } catch {
            print("Error navigating to: \(AppRoute.screenTwo)")
        }
    }
    }


