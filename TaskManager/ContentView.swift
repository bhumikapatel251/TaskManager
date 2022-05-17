//
//  ContentView.swift
//  TaskManager
//
//  Created by Bhumika Patel on 10/05/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        NavigationView{
            Home()
                .navigationTitle("TaskManager")
                .navigationBarTitleDisplayMode(.inline)
        }
       
    }

    
}

  


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
