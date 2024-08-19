//
//  AddressSelection.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/19/24.
//

import SwiftUI

struct AddressSelection: View {
    @Binding var isPresented: Bool
    @State var vm = LocationSearchService()

    var body: some View {
        NavigationView { //only added so searchbar appears as expected
            VStack {
                if vm.results.isEmpty {
                    ContentUnavailableView("No results", systemImage: "questionmark.square.dashed")
                } else {
                    List(vm.results) { result in
                        VStack(alignment: .leading) {
                            Text(result.title)
                            Text(result.subtitle).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .searchable(text: $vm.query)
    }
}

//#Preview {
//    AddressSelection()
//}

