//
//  ContentView.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/6/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var orderModelOrders: [Order]
    @Environment(\.modelContext) private var context //how to CRUD state
    @StateObject private var appState = AppStateModel() // this is
    
    let modelContainer: ModelContainer
    
    init() {
        do {
            //TODO: add memory stuff https://www.hackingwithswift.com/quick-start/swiftdata/how-to-add-multiple-configurations-to-a-modelcontainer
            modelContainer = try ModelContainer(for: Order.self, Customer.self, Driver.self)
        } catch {
            print(error)
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    
    var body: some View {
        NavigationStack { //If wanting to navigate this has to wrap the entire component
            VStack {
                
                // this is how to align horizontally
                FirstPage()
            }.navigationViewStyle(.stack)
            //this doesn;t work for now, look up navigatgion architecture
//                .navigationDestination(for: AppRoute.self) { appRoute in
//                    
//                    switch appRoute {
//                    case .screenOne:
//                        AvailableOrderScreen()
//                    case .screenTwo:
//                        CustomerMainScreen()
//                    case .screenThree:
//                        CustomerMainScreen()
//                    }
//                }
            
        }
        
    }
    
}
////////////////////////////////////////

#Preview {
    ContentView()
        .modelContainer(for: [Order.self, Customer.self, Driver.self, Route.self], inMemory: true).environmentObject(AppStateModel())
        //add this to access state and persist making it possible to CRUD state
       // https://developer.apple.com/tutorials/develop-in-swift/save-data
}



//just buttons
//HStack {
//    // the order od modifieres matters
//    //
//    MyButton(title:"Yes", onPress: signIn, backgroundColor: Color.blue, image: "checkmark", frame: buttonFrame)
//    
//    Spacer() //how to space evenly
//    
//    MyButton(title:"No", onPress: no, backgroundColor: Color.red, image: "xmark", frame: buttonFrame)
//
//    
//}.frame(width: 180)
