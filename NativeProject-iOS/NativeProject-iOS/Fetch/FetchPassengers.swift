//
//  FetchPassengers.swift
//  NativeProject-iOS
//
//  Created by Otto Tuhkunen on 4.5.2023.
//

import Foundation
import Alamofire

// using Alamofire to fetch passengers from dummyJSON:
class PassengerAPI: ObservableObject {
    private let baseURL = "https://dummyjson.com/users"
    
    // all requests to backend:

    // get a list of all passengers:
    func fetchPassengers(completion: @escaping ([Passenger]) -> Void) {
        let url = "https://dummyjson.com/users"
        AF.request(url).validate().responseDecodable(of: PassengerResponse.self) { response in
            switch response.result {
            case .success(let passengerResponse):
                completion(passengerResponse.users)
            case .failure(let error):
                print("Error fetching passengers: \(error)")
                completion([])
            }
        }
    }

    // get passenger with query (search function):
    func searchPassengers(query: String, completion: @escaping ([Passenger]) -> Void) {
        let searchURL = "\(baseURL)/search?q=\(query)"

        AF.request(searchURL).validate().responseDecodable(of: SearchPassengerResponse.self) { response in
            switch response.result {
            case .success(let usersResponse):
                completion(usersResponse.users)
            case .failure(let error):
                print("Error fetching passengers: \(error)")
            }
        }
    }
    
    // add new passenger:
    func addPassenger(firstName: String, lastName: String, birthDate: Date, email: String, phoneNumber: String, completion: @escaping (Passenger?) -> Void) {
        let urlString = "https://dummyjson.com/users/add"
        print("addPassenger called")
        
        // converting Date to String in correct format for JSON:
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        let birthDateString = dateFormatter.string(from: birthDate)
        let parameters: [String: String] = ["firstName": firstName, "lastName": lastName, "birthDate": birthDateString, "email": email, "phone": phoneNumber]

        AF.request(urlString, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: Passenger.self) { response in
                switch response.result {
                case .success(let newPassenger):
                    print("adding passenger: ", newPassenger)
                    completion(newPassenger)
                case .failure(let error):
                    print("Error adding passenger:", error)
                    completion(nil)
            }
        }
    }

    // update passenger information:
    func updatePassenger(id: Int, newFirstName: String, newLastName: String, newBirthDate: String, newEmail: String, newPhoneNumber: String, completion: @escaping (Passenger?) -> Void) {
        let urlString = "https://dummyjson.com/users/\(id)"
        let parameters: [String: String] = ["firstName": newFirstName, "lastName": newLastName, "birthDate": newBirthDate, "email": newEmail, "phone": newPhoneNumber]

        // using .put to set new data:
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


    // delete passenger from list:
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
