//
//  EditPassenger.swift
//  NativeProject-iOS
//
//  Created by Otto Tuhkunen on 7.5.2023.
//

import SwiftUI

/// View - Edit passenger details
/// - user can edit passenger name, birth date, email and phone number
/// - Parameter showAlert: used to alert user of edited passenger (alert contains passenger modified name)
struct EditPAXView: View {
    var passenger: Passenger
    @ObservedObject var passengerAPI = PassengerAPI()
    @State private var firstName: String
    @State private var lastName: String
    @State private var birthDate: String
    @State private var email: String
    @State private var phoneNumber: String
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    init(passenger: Passenger) {
        self.passenger = passenger
        _firstName = State(initialValue: passenger.firstName)
        _lastName = State(initialValue: passenger.lastName)
        _birthDate = State(initialValue: passenger.birthDate)
        _email = State(initialValue: passenger.email)
        _phoneNumber = State(initialValue: passenger.phone)
    }

    var body: some View {
        Form {
            /// - Header, passenger information
            Section(header: Text("Passenger information")) {
                TextField("First name", text: $firstName)
                TextField("Last name", text: $lastName)
                TextField("Birth date", text: $birthDate)
            }
            /// - contact information
            Section(header: Text("Contact information")) {
                TextField("Email", text: $email)
                TextField("Phone number", text: $phoneNumber)
            }
            Section {
                /// Update button
                /// - This updates the user (calls backend service)
                Button("Update") {
                    passengerAPI.updatePassenger(id: passenger.id, newFirstName: firstName, newLastName: lastName, newBirthDate: birthDate, newEmail: email, newPhoneNumber: phoneNumber) { updatedPassenger in
                        if let _ = updatedPassenger {
                            showAlert = true
                        }
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Success"), message: Text("Passenger details for \(firstName) \(lastName) have been updated!"), dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }
        }
        .navigationBarTitle("Edit \(passenger.firstName) \(passenger.lastName)", displayMode: .inline)
    }
}
