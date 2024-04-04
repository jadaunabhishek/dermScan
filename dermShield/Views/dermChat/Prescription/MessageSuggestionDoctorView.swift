//
//  MessageSuggestionView.swift
//  dermShield - Doctors
//
//  Created by Abhishek Jadaun on 29/01/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseInternal

struct MessageSuggestionDoctorView: View {
    
    @ObservedObject private var viewModelCases = AllCasesViewModel()
    
    var doctorDetails: AllMessageFromDoctor
    @Environment(\.presentationMode) var presentationMode
    
    @State private var prescription: String = ""
    @State private var userProfile: UserProfile?
    
    // variables to store to database
    @State private var physicalAssistance: String = ""
    @State private var givePrescription: String = ""
    
    let assistance = ["Select", "Required", "Not Required"]
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Doctors's Details")) {
                    HStack {
                        Text("Full Name ")
                            .foregroundColor(.gray)
                        Text(doctorDetails.fullName)
                    }
                    
                    HStack {
                        Text("Gender ")
                            .foregroundColor(.gray)
                        Text(doctorDetails.gender)
                    }
                    
                    HStack {
                        Text("Age ")
                            .foregroundColor(.gray)
                        Text(doctorDetails.age)
                    }
                    
                    HStack {
                        Text("Physical Assistance ")
                            .foregroundColor(.gray)
                        Text(doctorDetails.physicalAssistance)
                    }
                    
                    HStack {
                        Text("Prescription ")
                            .foregroundColor(.gray)
                        Text(doctorDetails.givePrescription)
                    }
                    
                }
                VStack {
                    Button {
                        print("Message suggestion doctor details: ")
                        print(doctorDetails.scanID)
                        viewModelCases.updateCaseStatus(scanID: doctorDetails.scanID)
                    } label: {
                        Text("Satisfied")
                            .foregroundColor(Color.green)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                
//                VStack {
//                    Button {
//                        
//                    } label: {
//                        Text("Not satisfied")
//                            .foregroundColor(Color.red)
//                    }
//                }
//                .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .navigationBarTitle("Prescription details", displayMode: .inline)
            Spacer()
        }
    }
}

struct MessageSuggestionDoctorView_Preview: PreviewProvider {
    static var previews: some View {
        MessageSuggestionDoctorView(doctorDetails: AllMessageFromDoctor(
            userID: "3434", fullName: "Abhishek Jadaun",
            gender: "Male",
            age: "20",
            physicalAssistance: "Not Required",
            givePrescription: "You are healthy prescription", scanID: "343434", imageURL: URL(string: "djfk")
        ))
    }
}
