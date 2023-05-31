//
//  ListOfPassengers.swift
//  NativeProject-iOS
//
//  Created by Otto Tuhkunen on 7.5.2023.
//

import SwiftUI

/// Second tabView of the app with a list of all passengers
/// - One passenger contains  name, birth date, email and phone number
/// - Passengers are only shown if a flight is loaded
struct PAXListView: View {
    @State private var passengers: [Passenger] = []
    private let passengerAPI = PassengerAPI()
    var selectedFlight: UUID?
    @State private var isLoading = false

    var body: some View {
        VStack {
            // list of all passengers:
            if let _ = selectedFlight {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                List(passengers) { passenger in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(passenger.firstName) \(passenger.lastName)")
                            .font(.headline)
                        Text("Date of birth: \(passenger.birthDate)")
                        Text("Email: \(passenger.email)")
                        Text("Phone: \(passenger.phone)")
                    }
                }
            } else {
                HStack {
                    Text("Select a flight to view passenger manifest!")
                        .font(.headline)
                    Image(systemName: "airplane.departure")
                }
            }
        }
        .padding()
        .onAppear {
            isLoading = true
            passengerAPI.fetchPassengers { fetchedPassengers in
                passengers = fetchedPassengers
                isLoading = false
            }
        }
    }
}
