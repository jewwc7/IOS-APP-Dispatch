//
//  AddressSelection.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/19/24.
//

import SwiftUI

// convert pay to currency
// Make better available Order cards
// Clean up that screens UI/ Remove the toogle and put the shopping cart as a tab view?
// What happens when I decline an order?
// Then add sorting and filtering to list(CUstomer order list, etc) review the youtube vid
struct AddressSelection: View {
    @State var locationSearchService = LocationSearchService()
    @Binding var address: LocationResult
    @Environment(\.presentationMode) var presentationMode // auto avaialble
    //  @Binding var addressTwo: String?

    var body: some View {
        NavigationView { // only added so searchbar appears as expected
            VStack {
                if locationSearchService.results.isEmpty {
                    ContentUnavailableView("No results", systemImage: "questionmark.square.dashed")
                } else {
                    List(locationSearchService.results) { result in
                        VStack(alignment: .leading) {
                            Text(result.title)
                            Text(result.subtitle).font(.caption).foregroundStyle(.secondary)
                        }.onTapGesture {
                            handleResultSelection(result)
                        } // .contentShape(Rectangle()) supposed to allow click on entire list element but not working https://stackoverflow.com/questions/62640073/hstack-ontapgesture-only-works-on-elements
                    }
                }
            }
        }
        .searchable(text: $locationSearchService.query)
    }

    private func handleResultSelection(_ result: LocationResult) {
//        DispatchQueue.main.async { // "modifying state during view update", some reason assigning the address causes this. Looked up but didn;t find anything that worked, wrapping it in this doesn;t work. https://stackoverflow.com/questions/71953853/swiftui-map-causes-modifying-state-during-view-update
//            address = result
//        }
        address = result
        presentationMode.wrappedValue.dismiss() // Go back after selecting an address
    }
}

// #Preview {
//    AddressSelection(isPresented: constant(true), address: Binding<String>)
// }
