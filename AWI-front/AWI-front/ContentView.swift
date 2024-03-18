//
//  ContentView.swift
//  AWI-front
//
//  Created by Thomas Coulon on 13/03/2024.
//

import SwiftUI


struct RedView: View {
    var body: some View {
        Color.red
    }
    //ICI
}

struct BlueView: View {
    var body: some View {
        AccueilView()
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
           RedView() // a remplacer par les models view de activité/inscirption ect
             .tabItem {
                Image(systemName: "phone.fill")
                Text("First Tab")
           }
           BlueView()
             .tabItem {
                Image(systemName: "tv.fill")
                Text("Second Tab")
          }
        }
    }
}

#Preview {
    ContentView()
}
