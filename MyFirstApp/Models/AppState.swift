//
//  AppState.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/24/24.
//


import SwiftData
import Foundation
import SwiftUI
import Combine

struct IAnimatedNotification {
     var isShowingMyNotification: Bool = false
     //var data: Content = Text("Hi")
}

class AppStateModel: ObservableObject {
    @Published var loggedInCustomer: Customer? = nil
    @Published var loggedInDriver: Driver? = nil
    @Published var isShowingMyNotification: Bool = false
    @Published var notificationAnimation = IAnimatedNotification()
    
    func login(customer: Customer) {
      loggedInCustomer = customer
    }
    
    //not in use yet, but will be the same thing as the customers just with drivers
    func loginDriver(driver: Driver){
    loggedInDriver = driver
    }
    
    func toggleNotification(){
        isShowingMyNotification.toggle()
    }
    
    func displayNotifcation(){
        UIApplication.shared.inAppNotification(adaptForDynmaicIsland: false, timeout: 5, swipeToClose: true) {

            HStack {
                Text("The driver in on their way to pickup order")
            }.padding().background(.blue)
        }
    }
}

