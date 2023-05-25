//
//  FlightModel.swift
//  NativeProject-iOS
//
//  Created by Otto Tuhkunen on 4.5.2023.
//

import Foundation

// Models

struct Flight: Identifiable {
    let id = UUID()
    let flightNumber: String
    let airline: String
    let gateNumber: String
    let destination: String
    let bookedPassengers: Int
}

// list of fake flights (no connection to backend):
// added to display how the app would look like in real operation

let flights: [Flight] = [
    Flight(flightNumber: "AY 1545", airline:"Finnair", gateNumber: "25", destination: "BRU / EBBR", bookedPassengers: 30),
    Flight(flightNumber: "AF 1071", airline:"Air France", gateNumber: "22", destination: "CDG / LFPG", bookedPassengers: 0),
    Flight(flightNumber: "D8 2616", airline:"Norwegian Air Sweden", gateNumber: "18", destination: "ARN / ESSA", bookedPassengers: 0)
]
