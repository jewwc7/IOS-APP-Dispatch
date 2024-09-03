//
//  StopViewModel.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/29/24.
//

import Foundation
import SwiftUI

struct StopUI {
    var buttonTitle: String
    var isButtonDisabled: Bool
}

struct StopUIInfo {
    var pickup: StopUI
    var dropoff: StopUI
}

class StopViewModel {
    var stop: Stop

    var missingKey: String {
        "Missing dictionary key"
    }

    init(_ stop: Stop) {
        self.stop = stop
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

    func buttonData() -> StopUIInfo {
        if let order = stop.order {
            return OrderViewModel(order).claimedTransitionButtonUI()
        } else {
            return StopUIInfo(pickup: StopUI(buttonTitle: "Invalid transition", isButtonDisabled: false), dropoff: StopUI(buttonTitle: "Invalid transition", isButtonDisabled: false))
        }
    }

    @ViewBuilder
    func textForDriverStopType() -> some View {
        switch StopType(rawValue: stop.stopType) {
        case .pickup:
            HStack {
                TextChip(title: "Pickup", bgColor: .blue, font: .footnote)
                Text(formattedDate(stop.dueAt)).font(.footnote).bold().foregroundStyle(.red)
            }

        // Use pickup properties if needed
        case .dropoff:
            HStack {
                TextChip(title: "Dropoff", bgColor: .orange, font: .footnote)
                Text(formattedDate(stop.dueAt)).font(.footnote).bold().foregroundStyle(.red)
            }

        case .none:
            ContentUnavailableView("Not a pickup or dropoff", systemImage: "xmark")
        }
    }
}
