//
//  PassengerModel.swift
//  NativeProject-iOS
//
//  Created by Otto Tuhkunen on 4.5.2023.
//

import Foundation

/// Models
/// Passenger Model
/// - Parameter id: user  id from dummyJSON (Int)
/// - Parameter firstName: user first name from dummyJSON
/// - Parameter lastName: user last name from dummyJSON
/// - Parameter birthDate: user birth date from dummyJSON (String)
/// - Parameter email: user email from dummyJSON
/// - Parameter phone: user phone number from dummyJSON
struct Passenger: Identifiable, Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let birthDate: String
    let email: String
    let phone: String
}

/// Response Models
/// - Response for passenger list
struct PassengerResponse: Decodable {
    let users: [Passenger]
}

/// - Response for search function (one user)
struct SearchPassengerResponse: Decodable {
    let users: [Passenger]
}
