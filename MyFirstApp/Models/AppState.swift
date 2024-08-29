//
//  AppState.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/24/24.
//

import Combine
import Foundation
import SwiftData
import SwiftUI

struct IAnimatedNotification {
    var isShowingMyNotification: Bool = false
    // var data: Content = Text("Hi")
}

class AppStateModel: ObservableObject {
    @Published var loggedInCustomer: Customer? = nil
    @Published var loggedInDriver: Driver? = nil
    @Published var isShowingMyNotification: Bool = false
    @Published var notificationAnimation = IAnimatedNotification()

    func login(customer: Customer) {
        loggedInCustomer = customer
    }

    // not in use yet, but will be the same thing as the customers just with drivers
    func loginDriver(driver: Driver) {
        loggedInDriver = driver
    }

    func toggleNotification() {
        isShowingMyNotification.toggle()
    }

    // Passing something to viewbuilder via a closure and not directly into the function params
    // In the displayNotification function within your AppStateModel class, viewBuilder is defined as a parameter of type @escaping () -> Content. This means viewBuilder is a closure that takes no arguments and returns an instance of Content, where Content conforms to the View protocol. The @escaping attribute indicates that the closure can escape the function, allowing it to be stored or executed later, which is necessary for asynchronous operations or operations that happen outside the immediate scope of the function, such as displaying a notification
    func displayNotification<Content: View>(viewBuilder: @escaping () -> Content) {
        UIApplication.shared.inAppNotification(adaptForDynmaicIsland: false, timeout: 5, swipeToClose: true) {
            viewBuilder().padding().background(.white)
        }
    }

    func displayNotificationTwo<Content: View>(viewBuilder: @escaping () -> Content) {
        UIApplication.shared.inAppNotification(adaptForDynmaicIsland: false, timeout: 2, swipeToClose: true) {
            GeometryReader { geometry in
                VStack(content: {
                    viewBuilder()
                }).frame(width: geometry.size.width, height: 40) // .overlay(  //looks funny, think because some UI is controlled withinAppNotification
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.red, lineWidth: 0.5)
//                )
                    .background(.black)
                // .shadow(color: .black, radius: 10, x: 0, y: 5)
            }
        }
    }
}
