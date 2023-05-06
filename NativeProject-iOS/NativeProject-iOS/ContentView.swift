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
                Label("All PAX", systemImage: "list.bullet.circle.fill")
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

// Page with a list of all passengers:
struct PAXListView: View {
    @State private var passengers: [Passenger] = []
    private let passengerAPI = PassengerAPI()
    var selectedFlight: UUID?

    var body: some View {
        VStack {
            // list of all passengers:
            if let _ = selectedFlight {
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
            passengerAPI.fetchPassengers { fetchedPassengers in
                passengers = fetchedPassengers
            }
        }
    }
}

// page to search, edit or delete passengers:
struct SearchView: View {
    @State private var searchQuery: String = ""
    @State private var searchResults: [Passenger] = []
    private let passengerAPI = PassengerAPI()
    var selectedFlight: UUID?
    
    var body: some View {
        VStack {
            if let _ = selectedFlight {
                HStack {
                    // search for a passenger:
                    TextField("Passenger name...", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)
                    
                    Button(action: {
                        passengerAPI.searchPassengers(query: searchQuery) { fetchedPassengers in
                            searchResults = fetchedPassengers
                        }
                    }, label: {
                        Text("Search")
                    })
                }
                // search results (different view:
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
        
// edit passenger details:
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
            Section(header: Text("Passenger information")) {
                TextField("First name", text: $firstName)
                TextField("Last name", text: $lastName)
                TextField("Birth date", text: $birthDate)
            }
            Section(header: Text("Contact information")) {
                TextField("Email", text: $email)
                TextField("Phone number", text: $phoneNumber)
            }
            Section {
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
                    DatePicker("Birth date", selection: $birthDate, displayedComponents: .date)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Phone number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                Section {
                    Button(action: {
                        isLoading = true
                        passengerAPI.addPassenger(firstName: firstName, lastName: lastName, birthDate: birthDate, email: email, phoneNumber: phoneNumber) { addedPassenger in
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
                        Alert(title: Text("Success"), message: Text("\(firstName) \(lastName) added to manifest!"), dismissButton: .default(Text("OK")) {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
