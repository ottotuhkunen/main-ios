//
//  ContentView.swift
//  NativeProject-iOS
//
//  Created by Otto Tuhkunen on 4.5.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedFlight: UUID?
    
    var body: some View {
        // tab view with all pages
        TabView {
            NavigationView {
                FlightsView(selectedFlight: $selectedFlight)
                    .navigationBarTitle("Select active flight")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Flights", systemImage: "airplane.circle.fill")
            }
            
            NavigationView {
                PAXListView(selectedFlight: selectedFlight)
                    .navigationBarTitle("Passenger manifest")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Manifest", systemImage: "list.bullet.circle.fill")
            }
            
            NavigationView {
                SearchView(selectedFlight: selectedFlight)
                    .navigationBarTitle("Search or delete passenger")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Search PAX", systemImage: "person.crop.circle.badge.questionmark.fill")
            }
            NavigationView {
                AddPAXView(selectedFlight: $selectedFlight)
                    .navigationBarTitle("Add passenger")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Add PAX", systemImage: "person.crop.circle.fill.badge.plus")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
