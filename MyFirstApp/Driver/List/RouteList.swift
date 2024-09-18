//
//  RouteList.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 9/17/24.
//

import SwiftUI

struct RouteList: View {
    var route: Route
    var loggedInDriver: Driver
    @Binding var previousNextStop: Stop?

    var body: some View {
        ForEach(route.makeStops(), id: \.id) { stop in
            DriverStopCard(stop: stop, driver: loggedInDriver, previousNextStop: $previousNextStop)
        }
    }
}

// #Preview {
//    RouteList()
// }
