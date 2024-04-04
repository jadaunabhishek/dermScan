////
////  MessageSuggestionView.swift
////  dermShield - Doctors
////
////  Created by Abhishek Jadaun on 29/01/24.
////
//
//import SwiftUI
//import FirebaseAuth
//import FirebaseDatabase
//import FirebaseDatabaseInternal
//
//struct MessagePatientDetailsView: View {
//    
//    var patientDetails : AllMessageFromPatient
//    @Environment(\.presentationMode) var presentationMode
//    
//    @State private var prescription : String = ""
//    @State private var userProfile: UserProfile?
//    
//    // variables to store to database
//    @State private var physicalAssistance : String = ""
//    @State private var givePrescription : String = ""
//    
//    let assistance = ["Select", "Required", "Not Required"]
//    
//    
//    var body: some View {
//        VStack {
//            Form {
//                Section(header: Text("Patient's Details")) {
//                    HStack {
//                        Text("Full Name ")
//                            .foregroundColor(.gray)
//                        Text(patientDetails.fullName)
//                    }
//                    
//                    HStack {
//                        Text("Gender ")
//                            .foregroundColor(.gray)
//                        Text(patientDetails.gender)
//                    }
//                    
//                    HStack {
//                        Text("Age ")
//                            .foregroundColor(.gray)
//                        Text(patientDetails.age)
//                    }
//                    
//                    HStack {
//                        Text("Body Part ")
//                            .foregroundColor(.gray)
//                        Text(patientDetails.bodyPart)
//                    }
//                    
//                    HStack {
//                        Text("Duration ")
//                            .foregroundColor(.gray)
//                        Text(patientDetails.time)
//                    }
//                    
//                    HStack {
//                        Text("Symptoms ")
//                            .foregroundColor(.gray)
//                        Text("\(patientDetails.symptom) and \(patientDetails.extraSymptom)")
//                    }
//                    
//                }
//                
//                Section(header: Text("Shared image")) {
//                    Button(action: {
//                        
//                    }, label: {
//                        Text("Tap to view image")
//                    })
//                }
//            }
//            .navigationBarTitle("Request details", displayMode: .inline)
//        }
//    }
//}
//
//
//struct MessagePatientDetails_Preview: PreviewProvider {
//    static var previews: some View{
//        MessagePatientDetailsView(patientDetails: AllMessageFromPatient(
//            userIDPatient: "434334",
//            fullName: "John Doe",
//            gender: "Male",
//            age: "30",
//            bodyPart: "Head",
//            time: "12:00 PM",
//            symptom: "Headache",
//            extraSymptom: "Fever"
//        ))
//    }
//}
