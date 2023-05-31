//
//  FetchPassengers.swift
//  NativeProject-iOS
//
//  Created by Otto Tuhkunen on 4.5.2023.
//

import Foundation
import Alamofire

/// Using Alamofire to fetch passengers from dummyJSON:
/// - contains all requests to dummyJSON backend
class PassengerAPI: ObservableObject {
    private let baseURL = "https://dummyjson.com/users"

    /// get a list of all passengers from backend
    /// - returns: if success, list of users. If error, error message
    func fetchPassengers(completion: @escaping ([Passenger]) -> Void) {
        let url = "https://dummyjson.com/users"
        AF.request(url).validate().responseDecodable(of: PassengerResponse.self) { response in
            switch response.result {
            case .success(let passengerResponse):
                completion(passengerResponse.users)
            case .failure(let error):
                print("Error: \(error)")
                completion([])
            }
        }
    }

    /// get user with query (search function) from backend
    /// - returns: usersResponse (data of one user), if error occurs, returns error code
    func searchPassengers(query: String, completion: @escaping ([Passenger]) -> Void) {
        let searchURL = "\(baseURL)/search?q=\(query)"
        
        AF.request(searchURL).validate().responseDecodable(of: SearchPassengerResponse.self) { response in
            switch response.result {
            case .success(let usersResponse):
                completion(usersResponse.users)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    /// add new passenger to backend
    /// - adding user with first name, last name, birth date, email and phone number
    /// - returns: completion(newPassenger) including information about the inserted user
    func addPassenger(firstName: String, lastName: String, birthDate: Date, email: String, phoneNumber: String, completion: @escaping (Passenger?) -> Void) {
        let urlString = "https://dummyjson.com/users/add"
        print("addPassenger called")
        
        /// - converting Date to String in correct format for JSON:
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        /// - formatting birth date to correct format (string)
        let birthDateString = dateFormatter.string(from: birthDate)
        /// - adding all parameters from user input
        let parameters: [String: String] = ["firstName": firstName, "lastName": lastName, "birthDate": birthDateString, "email": email, "phone": phoneNumber]

        AF.request(urlString, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: Passenger.self) { response in
                switch response.result {
                case .success(let newPassenger):
                    print("adding passenger: ", newPassenger)
                    completion(newPassenger)
                case .failure(let error):
                    print("Error:", error)
                    completion(nil)
            }
        }
    }

    /// Update user in backend
    /// - updating an already existing user in dummyJSON backend
    /// - compulsory values: firstName, lastName, birthDate, email and phone
    /// - returns: information about updated user in backend. This is used to notify user about the new information
    func updatePassenger(id: Int, newFirstName: String, newLastName: String, newBirthDate: String, newEmail: String, newPhoneNumber: String, completion: @escaping (Passenger?) -> Void) {
        let urlString = "https://dummyjson.com/users/\(id)"
        let parameters: [String: String] = ["firstName": newFirstName, "lastName": newLastName, "birthDate": newBirthDate, "email": newEmail, "phone": newPhoneNumber]

        /// - using .put to set new data:
        AF.request(urlString, method: .put, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: Passenger.self) { response in
                switch response.result {
                case .success(let updatedPassenger):
                    completion(updatedPassenger)
                case .failure(let error):
                    print("Error updating passenger:", error)
                    completion(nil)
            }
        }
    }

    /// delete passenger from backend
    /// - deleting one passenger from backend (initiated by button press)
    /// - returns: true, if error, returns error code and false.
    func deletePassenger(id: Int, completion: @escaping (Bool) -> Void) {
        let urlString = "https://dummyjson.com/users/\(id)"

        AF.request(urlString, method: .delete)
            .validate()
            .responseDecodable(of: Passenger.self) { response in
                switch response.result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Error deleting passenger:", error)
                    completion(false)
            }
        }
    }
}
