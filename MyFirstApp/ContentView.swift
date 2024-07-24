//
//  ContentView.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/6/24.
//

import SwiftUI
import SwiftData




final class AppState: ObservableObject {
  @Published var path = NavigationPath()
  // Can't be optional.
  // Manage in parent to inject state into "child" views
 // @Published var screenTwoData = ?
  @Published var isScreenTwoFlowActive: Bool = false
}

struct ContentView: View {
//    @StateObject private var appState = AppState()
     @Query private var appState: AppModel
    @Environment(\.modelContext) private var context //how to CRUD state
    
    var body: some View {
        NavigationStack() { //If wanting to navigate this has to wrap the entire component
            VStack {
                
                // this is how to align horizontally
                FirstPage()
            }.navigationViewStyle(.stack)
                .navigationDestination(for: AppModel.self) { appModel in
                    switch appModel.path {
                    case .screenOne:
                        FirstPage()
                    case .screenTwo:
                        AvailableOrderScreen()
                    case .screenThree:
                        CustomerMainScreen()
                    }
                }
            
        }
        
    }
    
}
////////////////////////////////////////

#Preview {
    ContentView()
//        .modelContainer(for: OrderModel.self, inMemory: true)
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
