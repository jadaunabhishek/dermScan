//
//  UserProfileView.swift
//  dermShield - Doctors
//
//  Created by Abhishek Jadaun on 29/01/24.
//

import SwiftUI

struct UserProfile {
    var userId: String
    var name: String
    var gender: String
    var age: String
    var countryOfResidence: String
    var city: String
    var postCode: String
    var about: String
    var specialization: String
    var clinic: String
    var clinicAddress: String
    var workWeekFrom: String
    var workWeekTo: String
    var nationalID: String
    var nmcNumber: String
    
    // Add this method to convert the user profile to a dictionary
    func dictionaryRepresentation() -> [String: Any] {
        return [
            "userId": userId,
            "name": name,
            "gender": gender,
            "age": age,
            "countryOfResidence": countryOfResidence,
            "city": city,
            "postCode": postCode,
            "about": about,
            "specialization": specialization,
            "clinic": clinic,
            "clinicAddress": clinicAddress,
            "workWeekFrom": workWeekFrom,
            "workWeekTo": workWeekTo,
            "nationalID": nationalID,
            "nmcNumber": nmcNumber
        ]
    }
}
