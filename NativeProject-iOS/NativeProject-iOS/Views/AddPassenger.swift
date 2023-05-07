//
//  AddPassenger.swift
//  NativeProject-iOS
//
//  Created by Otto Tuhkunen on 7.5.2023.
//

import SwiftUI

// add a passenger:
struct AddPAXView: View {
    private let passengerAPI = PassengerAPI()
    @Binding var selectedFlight: UUID?
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthDate = Date()
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = false
    
    // add button visible only when name is filled
    private var addButtonDisabled: Bool {
        firstName.isEmpty || lastName.isEmpty
    }

    var body: some View {
        if let _ = selectedFlight {
            Form {
                Section(header: Text("Passenger name")) {
                    TextField("First name", text: $firstName)
                    TextField("Last name", text: $lastName)
                }
                Section(header: Text("Information")) {
                    DatePicker("Birth date",
                       selection: $birthDate,
                       displayedComponents: .date)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Phone number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                Section {
                    Button(action: {
                        isLoading = true
                        passengerAPI.addPassenger(
                            firstName: firstName,
                            lastName: lastName,
                            birthDate: birthDate,
                            email: email,
                            phoneNumber: phoneNumber) { addedPassenger in
                            if let _ = addedPassenger {
                                showAlert = true
                            }
                            isLoading = false
                        }
                    }) {
                        // loading icon:
                        HStack {
                            Text("Add")
                            Spacer()
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                        }
                    }
                    .disabled(addButtonDisabled)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Success"),
                              message: Text("\(firstName) \(lastName) added to manifest!"),
                              dismissButton: .default(Text("OK")) {
                            presentationMode.wrappedValue.dismiss()
                        })
                    }
                }
            }
            .navigationTitle("Add Passenger")
        } else {
            VStack {
                HStack {
                    Text("Select a flight to view passenger manifest!")
                        .font(.headline)
                    Image(systemName: "airplane.departure")
                }
            }
        }
    }
}
