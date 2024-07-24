//
//  CustomerMainScreen.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/21/24.
//

import SwiftUI

struct CustomerMainScreen: View {
    let list:[ListOptions] = [
        ListOptions(title: "Create Order", destination: CreateOrderScreen()),
        ListOptions(title: "My Created Orders", destination: MyCreatedOrders())
    ]
    
    var body: some View {

        NavigationStack {
                List {
                    ForEach(list){ item in
                        NavigationLink(destination: AnyView(item.destination)) { //AnyView is dicouraged, but i'll figure that out late
                            //https://stackoverflow.com/questions/75085615/swiftui-providing-destination-for-navigationlink-in-the-view-init-resulting-in
                            Text(item.title)
                        }
                        
                    }.navigationTitle("Customer Home").listStyle(.insetGrouped)
                }
            }
        }
    
    
}

#Preview {
    CustomerMainScreen()
}

struct ListOptions:Identifiable {
    var id = UUID() //needs to be added to make it conform to Identifiable
    var title: String
    var destination: (any View) //how to type a view
}

// why does this screen show up as a little blue icon when swiping to it from main app?
