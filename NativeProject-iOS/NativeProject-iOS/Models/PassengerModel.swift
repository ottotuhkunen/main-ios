//
//  PassengerModel.swift
//  NativeProject-iOS
//
//  Created by Otto Tuhkunen on 4.5.2023.
//

import Foundation

// Models

struct Passenger: Identifiable, Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let birthDate: String
    let email: String
    let phone: String
}

// Response models

struct PassengerResponse: Decodable {
    let users: [Passenger]
}

struct SearchPassengerResponse: Decodable {
    let users: [Passenger]
}
