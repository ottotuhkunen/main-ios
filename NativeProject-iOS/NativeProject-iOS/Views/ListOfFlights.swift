//
//  ListOfFlights.swift
//  NativeProject-iOS
//
//  Created by Otto Tuhkunen on 7.5.2023.
//

import SwiftUI

struct FlightsView: View {
    @Binding var selectedFlight: UUID?
    
    var body: some View {
        List {
            ForEach(flights) { flight in
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(flight.flightNumber)")
                            .font(.headline)
                        Text("\(flight.airline)")
                            .font(.headline)
                        Text("Gate: \(flight.gateNumber)")
                        Text("Destination: \(flight.destination)")
                        Text("Passengers: \(flight.bookedPassengers)")
                    }
                    Spacer()
                    // radiobutton to select a flight
                    // not selectable if PAX amount is 0
                    RadioButton(selectedId: $selectedFlight, id: flight.id, isEnabled: flight.bookedPassengers > 0)
                }
                .padding(.vertical)
            }
        }
    }
}

// radio button for flights list:
// button is disabled if PAX amount is 0
struct RadioButton: View {
    @Binding var selectedId: UUID?
    let id: UUID
    let isEnabled: Bool
    
    var body: some View {
        Button(action: {
            if isEnabled {
                selectedId = id
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(selectedId == id ? Color.blue : Color.gray, lineWidth: 2)
                    .frame(width: 24, height: 24)
                if selectedId == id {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.blue)
                        .frame(width: 16, height: 16)
                }
            }
            .opacity(isEnabled ? 1.0 : 0.5) // Apply opacity to disabled radio buttons
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled) // Disable the button when isEnabled is false
    }
}
