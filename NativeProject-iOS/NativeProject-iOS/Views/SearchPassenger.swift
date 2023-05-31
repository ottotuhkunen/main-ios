//
//  SearchPassenger.swift
//  NativeProject-iOS
//
//  Created by Otto Tuhkunen on 7.5.2023.
//

import SwiftUI

/// third tabView of the app to search, edit or delete passengers
/// - Search button to initiate query
/// - contains HStack with passenger details
/// - each passenger have 2 buttons, Edit and Delete
/// - a flight needs to be loaded on first tabView for this to work
struct SearchView: View {
    @State private var searchQuery: String = ""
    @State private var searchResults: [Passenger] = []
    private let passengerAPI = PassengerAPI()
    var selectedFlight: UUID?
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if let _ = selectedFlight {
                HStack {
                    /// - search for a passenger:
                    TextField("Passenger name...", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)
                    
                    Button(action: {
                        isLoading = true
                        passengerAPI.searchPassengers(query: searchQuery) { fetchedPassengers in
                            searchResults = fetchedPassengers
                            isLoading = false
                        }
                    }, label: {
                        Text("Search")
                    })
                }
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                /// - search results (different view:
                SearchResultsView(passengers: searchResults, passengerAPI: passengerAPI)

            } else {
                HStack {
                    Text("Select a flight to view passenger manifest!")
                        .font(.headline)
                    Image(systemName: "airplane.departure")
                }
            }
        }
        .padding()
    }
}

// search results:
struct SearchResultsView: View {
    var passengers: [Passenger]
    @ObservedObject var passengerAPI: PassengerAPI
    @State private var showRemoveAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        List(passengers, id: \.id) { passenger in
            VStack(alignment: .leading, spacing: 8) {
                Text("\(passenger.firstName) \(passenger.lastName)")
                    .font(.headline)
                Text("Date of birth: \(passenger.birthDate)")
                Text("Email: \(passenger.email)")
                Text("Phone: \(passenger.phone)")
                
                HStack {
                    // edit passenger details:
                    Button(action: {}) {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }
                    .overlay(
                        NavigationLink(destination: EditPAXView(passenger: passenger), label: {
                            EmptyView()
                        }).opacity(0)
                    )
                    
                    Spacer()
                    
                    // delete passenger:
                    Button(action: {
                        passengerAPI.deletePassenger(id: passenger.id) { deletedPassenger in
                            alertMessage = "You have removed \(passenger.firstName) \(passenger.lastName) from flight AY 1545."
                            showRemoveAlert = true
                        }
                    }) {
                        Image(systemName: "trash.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(PlainButtonStyle()) // Add this line
                }
            }
            .padding(.vertical)
        }
        .alert(isPresented: $showRemoveAlert) {
            Alert(title: Text("Passenger Removed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
