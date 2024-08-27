//
//  DriverOrderCard.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/5/24.
//

import SwiftData
import SwiftUI

struct DriverStopCard: View {
    @State private var isExpanded: Bool = false
    var stop: Stop
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        textForStopType(stop)
                            .font(.subheadline)
                        Text(stop.fullAddress)
                            .font(.headline)
                    }
                   
                }.padding()
            
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .padding()
                }
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            // Content
            if isExpanded {
                ExpandedDriverStopCard(stop: stop).transition(.opacity) // Transition effect when expanding/collapsing
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 5)
    }
    
    @ViewBuilder
    func textForStopType(_ stop: Stop) -> some View {
        switch StopType(rawValue: stop.stopType) {
        case .pickup:
            Text("Pickup by \(formattedDate(stop.dueAt))")
                .font(.headline)
                .foregroundColor(.green)
        // Use pickup properties if needed
        case .dropoff:
            Text("Dropoff by \(formattedDate(stop.dueAt))")
                .font(.headline)
                .foregroundColor(.blue)
        // Use dropoff properties if needed
        case .none:
            ContentUnavailableView("Not a pickup or dropoff", systemImage: "xmark")
        }
    }
}

// #Preview {
//    ModelPreview { order in
//        DriverStopCard(order: order)
//    }.environmentObject(AppStateModel())
// }
