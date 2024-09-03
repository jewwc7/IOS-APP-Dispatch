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

    var chipColor: Color {
        return order.inProgess ? .blue : order.claimed ? .orange : order.delivered ? .green : .red
    }

    var progressValue: Double {
        // This line attempts to find the index of the currentStatus in the array of all possible OrderStatus cases (OrderStatus.allCases).
        // If currentStatus is not found in OrderStatus.allCases, the guard statement returns 0.0, indicating no //progress.
        // If not claimed ahould be at 0
        let currentStatus = order.claimedStatuses.firstIndex(of: order.comparableStatus)

        guard let index = currentStatus else {
            return 0.0
        }
        // I want claimed to start, index is 0 for claim, so need to add 1 to every index
        return Double(index + 1) / Double(order.claimedStatuses.count)
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
