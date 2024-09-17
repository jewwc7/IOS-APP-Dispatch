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

    init(route: Route, loggedInDriver: Driver) {
        self.route = route
        self.loggedInDriver = loggedInDriver
    }

    var body: some View {
        ForEach(route.makeStops(), id: \.id) { stop in
            DriverStopCard(stop: stop, driver: loggedInDriver)
        }
    }
}

// #Preview {
//    RouteList()
// }
