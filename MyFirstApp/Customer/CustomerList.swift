//
//  CustomerList.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/25/24.
//

import Foundation
import SwiftUI
import SwiftData

struct CustomerList: View {
    @Environment(\.modelContext) private var context //how to CRUD state
    @Query private var customers: [Customer]
    
    var body: some View {
   // #TODo: Add popup Create ->Pop Up=> enter needed info -> save
        NavigationStack {
            List {
                ForEach(customers,  id: \.id){ customer in
                    
                    NavigationLink(destination: CustomerMainScreen()) {
                        Text(customer.name)
                    }
                    
                }.onDelete(perform: deleteCustomer)
                
            }.navigationTitle("Customer List").listStyle(.insetGrouped)
        }
        MyButton(title: "Create Customer", onPress: create, backgroundColor: Color.blue, image:"checkmark", frame: (Frame(height: 40))).frame(maxWidth: .infinity)
    }
    
    func create(){
        let newCustomer = Customer(name:"John Doe")
        context.insert(newCustomer)
        do {
            try context.save()
        } catch {
            print("Error creating customer: \(newCustomer)")
        }
    }
    private func deleteCustomer(offsets: IndexSet) {
        print(1324)
         withAnimation {
             for index in offsets {
                 print(customers[index])
                 context.delete(customers[index])
             }
         }
     }
    
}




#Preview {
    CustomerList().modelContainer(for: Customer.self, inMemory: true)
}

// why does this screen show up as a little blue icon when swiping to it from main app?
