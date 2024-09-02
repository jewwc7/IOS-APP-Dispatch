//
//  OrderViewModel.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/29/24.
//

import Foundation
import SwiftUI

class OrderViewModel {
    var order: Order

    var missingKey: String {
        "Missing dictionary key"
    }

    init(_ order: Order) {
        self.order = order
    }

    func chipColor() -> Color {
        return order.inProgess || order.delivered ? .green : order.claimed ? .blue : .red
    }

    func claimedTransitionButtonUI() -> StopUIInfo {
        let statusTexts = order.statusTexts
        let enRouteText = statusTexts[OrderStatus.enRouteToPickup.rawValue] ?? missingKey
        let atPickupText = statusTexts[OrderStatus.atPickup.rawValue] ?? missingKey
        let enRouteToDropoffText = statusTexts[OrderStatus.enRouteToDropoff.rawValue] ?? missingKey
        let atDropoffText = statusTexts[OrderStatus.atDropoff.rawValue] ?? missingKey
        let deliveredText = statusTexts[OrderStatus.delivered.rawValue] ?? missingKey
        let pickedUpText = "Picked up"

        if order.claimed {
            return StopUIInfo(pickup: StopUI(buttonTitle: enRouteText, isButtonDisabled: false), dropoff: StopUI(buttonTitle: atDropoffText, isButtonDisabled: true))
        }
        if order.enrouteToPickup {
            return StopUIInfo(pickup: StopUI(buttonTitle: atPickupText, isButtonDisabled: false), dropoff: StopUI(buttonTitle: atDropoffText, isButtonDisabled: true))
        }
        if order.atPickup {
            return StopUIInfo(pickup: StopUI(buttonTitle: enRouteToDropoffText, isButtonDisabled: false), dropoff: StopUI(buttonTitle: atDropoffText, isButtonDisabled: true))
        }
        if order.enrouteToDropoff {
            return StopUIInfo(pickup: StopUI(buttonTitle: pickedUpText, isButtonDisabled: true), dropoff: StopUI(buttonTitle: atDropoffText, isButtonDisabled: false))
        }
        if order.atDropoff {
            return StopUIInfo(pickup: StopUI(buttonTitle: pickedUpText, isButtonDisabled: true), dropoff: StopUI(buttonTitle: "Complete Delivery", isButtonDisabled: false))
        }
        if order.delivered {
            return StopUIInfo(pickup: StopUI(buttonTitle: pickedUpText, isButtonDisabled: true), dropoff: StopUI(buttonTitle: deliveredText, isButtonDisabled: true))
        } else {
            return StopUIInfo(pickup: StopUI(buttonTitle: "Invalid transition", isButtonDisabled: true), dropoff: StopUI(buttonTitle: "Invalid transition", isButtonDisabled: false))
        }
    }
}
