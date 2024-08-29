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
    var stopViewModel: StopViewModel
    init(stop: Stop) {
        self.stop = stop
        self.stopViewModel = StopViewModel(stop)
    }
   
    var body: some View {
        let buttonUI = stopViewModel.buttonForStopType()
        VStack(alignment: .leading) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        stopViewModel.textForDriverStopType()
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
                ExpandedDriverStopCard(stop: stop, buttonContent: {
                    MyButton(title: buttonUI.buttonTitle, onPress: handleOnPress, backgroundColor: Color.blue, image: "checkmark", frame: Frame(height: 40, width: 200), isDisabled: buttonUI.isButtonDisabled).frame(maxWidth: .infinity).disabled(buttonUI.isButtonDisabled)
                }).transition(.opacity) // Transition effect when expanding/collapsing
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
    
    func handleOnPress() {
        withAnimation(.smooth) {
            if let order = stop.order {
                order.handleStatusTransition()
            } else {
                print("stop has no associated order")
            }
        }
    }
}

// #Preview {
//    ModelPreview { order in
//        DriverStopCard(order: order)
//    }.environmentObject(AppStateManager())
// }
