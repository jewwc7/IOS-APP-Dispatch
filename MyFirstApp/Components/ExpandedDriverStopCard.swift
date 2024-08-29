//
//  ExpandedDriverStopCard.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/26/24.
//

import SwiftUI

struct StopUI {
    var buttonTitle: String
    var isButtonDisabled: Bool
}

struct ExpandedDriverStopCard: View {
    var stop: Stop
    
    struct UIInfo {
        var pickup: StopUI
        var dropoff: StopUI
    }

    var body: some View {
        let buttonUI = buttonForStopType()
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Organization")
                Text(stop.company).bold()
            }.padding(.vertical, 2)
            
            VStack(alignment: .leading) {
                Text("Address")
                Text(stop.fullAddress).bold()
            }.padding(.vertical, 2)
            HStack {
                VStack(alignment: .leading) {
                    Text("Contact name")
                    Text(stop.contactName).bold()
                }
                VStack(alignment: .leading) {
                    Text("Phone")
                    Text(stop.phoneNumber).bold()
                }
            }
            .padding(.vertical, 2)
           
            Divider()
            
            Spacer()
           
            MyButton(title: buttonUI.buttonTitle, onPress: handleOnPress, backgroundColor: Color.blue, image: "checkmark", frame: Frame(height: 40, width: 200), isDisabled: buttonUI.isButtonDisabled).frame(maxWidth: .infinity).disabled(buttonUI.isButtonDisabled)
            
        }.padding().overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
    
    func handleOnPress() {
        withAnimation(.smooth) {
            if let order = stop.order {
                order.handleStatusTransition()
            } else {
                print("stop has no associated order")
            }
        }
    }
    
    func buttonForStopType() -> StopUI {
        let stopUiData = buttonData()
       
        switch StopType(rawValue: stop.stopType) {
        case .pickup:
            return stopUiData.pickup
        case .dropoff:
            return stopUiData.dropoff
        case .none:
            return stopUiData.pickup
        }
    }
    
    func buttonData() -> UIInfo {
        if let order = stop.order {
            let statusTexts = order.statusTexts
            let enRouteText = statusTexts[OrderStatus.enRouteToPickup.rawValue] ?? missingKey
            let atPickupText = statusTexts[OrderStatus.atPickup.rawValue] ?? missingKey
            let enRouteToDropoffText = statusTexts[OrderStatus.enRouteToDropoff.rawValue] ?? missingKey
            let atDropoffText = statusTexts[OrderStatus.atDropoff.rawValue] ?? missingKey
            let deliveredText = statusTexts[OrderStatus.delivered.rawValue] ?? missingKey
            let pickedUpText = "Picked up"
          
            if order.claimed() {
                return UIInfo(pickup: StopUI(buttonTitle: enRouteText, isButtonDisabled: false), dropoff: StopUI(buttonTitle: atDropoffText, isButtonDisabled: true))
            }
            if order.isEnrouteToPickup() {
                return UIInfo(pickup: StopUI(buttonTitle: atPickupText, isButtonDisabled: false), dropoff: StopUI(buttonTitle: atDropoffText, isButtonDisabled: true))
            }
            if order.isAtPickup() {
                return UIInfo(pickup: StopUI(buttonTitle: enRouteToDropoffText, isButtonDisabled: false), dropoff: StopUI(buttonTitle: atDropoffText, isButtonDisabled: true))
            }
            if order.isEnrouteToDropoff() {
                return UIInfo(pickup: StopUI(buttonTitle: pickedUpText, isButtonDisabled: true), dropoff: StopUI(buttonTitle: atDropoffText, isButtonDisabled: false))
            }
            if order.isAtDropOff() {
                return UIInfo(pickup: StopUI(buttonTitle: pickedUpText, isButtonDisabled: true), dropoff: StopUI(buttonTitle: "Complete Delivery", isButtonDisabled: false))
            }
            if order.delivered() {
                return UIInfo(pickup: StopUI(buttonTitle: pickedUpText, isButtonDisabled: true), dropoff: StopUI(buttonTitle: deliveredText, isButtonDisabled: true))
            }
        }
        return UIInfo(pickup: StopUI(buttonTitle: "Invalid transition", isButtonDisabled: true), dropoff: StopUI(buttonTitle: "Invalid transition", isButtonDisabled: false))
    }
    
    var missingKey: String {
        "Missing dictionary key"
    }
}

// #Preview {
//    ExpandedDriverStopCard()
// }
