//
//  MessageView.swift
//  dermShield
//
//  Created by Abhishek Jadaun on 18/12/23.
//

import SwiftUI
import Firebase
import FirebaseDatabaseInternal
import FirebaseStorage

//struct AllMessageFromPatient {
//    var userIDPatient: String
//    var fullName: String
//    var gender: String
//    var age: String
//    var bodyPart: String
//    var time: String
//    var symptom: String
//    var extraSymptom: String
//}

//class AllMessagesFromPatientViewModel: ObservableObject {
//    @Published var users = [AllMessageFromPatient]()
//
//    init() {
//        fetchAllUsers()
//    }
//
//    private func fetchAllUsers() {
//        
//        let databaseRef = Database.database().reference().child("message/requestByPatient/\(userID)")
//
//        databaseRef.observe(.value) { snapshot in
//            var messages = [AllMessageFromPatient]()
//
//            for case let childSnapshot as DataSnapshot in snapshot.children {
//                if let userData = childSnapshot.value as? [String: Any] {
//                    if let userIDPatient = userData["userIDPatient"] as? String,
//                       let fullName = userData["fullName"] as? String,
//                       let gender = userData["gender"] as? String,
//                       let age = userData["age"] as? String,
//                       let bodyPart = userData["bodyPart"] as? String,
//                       let time = userData["time"] as? String,
//                       let symptom = userData["symptom"] as? String,
//                       let extraSymptom = userData["extraSymptom"] as? String {
//
//                        let mes = AllMessageFromPatient(
//                            userIDPatient: userIDPatient,
//                            fullName: fullName,
//                            gender: gender,
//                            age: age,
//                            bodyPart: bodyPart,
//                            time: time,
//                            symptom: symptom,
//                            extraSymptom: extraSymptom
//                        )
//
//                        messages.append(mes)
//                    }
//                }
//            }
//
//            self.users = messages
//        }
//    }
//}


struct AllMessageFromDoctor {
    var userID: String
    var fullName: String
    var gender: String
    var age: String
    var physicalAssistance: String
    var givePrescription: String
    var scanID: String
    var imageURL: URL?
    
    init(userID: String, fullName: String, gender: String, age: String, physicalAssistance: String, givePrescription: String, scanID: String, imageURL: URL?) {
        self.userID = userID
        self.fullName = fullName
        self.gender = gender
        self.age = age
        self.physicalAssistance = physicalAssistance
        self.givePrescription = givePrescription
        self.scanID = scanID
        self.imageURL = imageURL
    }
    
}

class AllMessagesFromDoctorViewModel: ObservableObject {
    @Published var users = [AllMessageFromDoctor]()
    
    init() {
        fetchAllDoctors()
    }
    
    
    func fetchAllDoctors() {
        if let userID = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference().child("message/prescriptionByDoctor/\(userID)")
            let storageRef = Storage.storage().reference()
            
            let query = databaseRef.queryOrdered(byChild: "scanID")
            
            query.observe(.value) { snapshot  in
                var messages = [AllMessageFromDoctor]()
                var orderedScanIDs = [String]() // Array to maintain the order of scanIDs
                
                for child in snapshot.children.reversed() {
                    if let childSnapshot = child as? DataSnapshot,
                       let userData = childSnapshot.value as? [String: Any] {
                        if let userID = userData["userID"] as? String,
                           let fullName = userData["fullName"] as? String,
                           let gender = userData["gender"] as? String,
                           let age = userData["age"] as? String,
                           let physicalAssistance = userData["physicalAssistance"] as? String,
                           let givePrescription = userData["givePrescription"] as? String,
                           let scanID = userData["scanID"] as? String {
                            
                            orderedScanIDs.append(scanID) // Keep track of order
                            
                            // Fetch image URL from Storage
                            let imageRef = storageRef.child("doctors/profile/\(userID)/profileImage.jpg")
                            imageRef.downloadURL { (url, error) in
                                if let error = error {
                                    print("Error getting download URL: \(error)")
                                    return
                                }
                                
                                // Create AllCasesUser object with imageURL
                                let mes = AllMessageFromDoctor(
                                    userID: userID,
                                    fullName: fullName,
                                    gender: gender,
                                    age: age,
                                    physicalAssistance: physicalAssistance,
                                    givePrescription: givePrescription,
                                    scanID: scanID, 
                                    imageURL: url
                                )
                                
                                messages.append(mes)
                                
                                // Check if all cases are fetched
                                if messages.count == snapshot.childrenCount {
                                    // Reorder cases based on original snapshot order
                                    let orderedCases = orderedScanIDs.compactMap { scanID in
                                        messages.first { $0.scanID == scanID }
                                    }
                                    self.users = messages
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


struct MessageView: View {
    
    @ObservedObject private var viewModelDoctor = AllMessagesFromDoctorViewModel()
//    @ObservedObject private var viewModelPatient = AllMessagesFromPatientViewModel()
    
    @State private var searchTerm = ""
    @State private var showFilters = false
    @State private var readFilter = false
    @State private var unreadFilter = false
    
    @State private var selectedSegment = 0
    
    var body: some View {
        NavigationStack {
            VStack {
//                Picker(selection: $selectedSegment, label: Text("")) {
//                    Text("Prescription").tag(0)
//                    Text("Request").tag(1)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding([.leading, .trailing])
//                .padding(.top, 10)
//                .padding(.bottom, 10)
                
//                ScrollView {
//                    switch selectedSegment {
//                    case 0:
                        ForEach(viewModelDoctor.users.indices, id: \.self) { i in
                            NavigationLink {
                                MessageSuggestionDoctorView(doctorDetails: viewModelDoctor.users[i])
                            } label: {
                                CustomMessageBox(message: viewModelDoctor.users[i])
                                    .padding(.top, 10)
                            }
                        }
                       
//                    case 1:
//                        ForEach(viewModelPatient.users.indices, id: \.self) { i in
//                            NavigationLink {
//                                MessagePatientDetailsView(patientDetails: viewModelPatient.users[i])
//                            } label: {
//                                CustomMessagePatientBox(message: viewModelPatient.users[i])
//                                    .padding(.top, 10)
//                            }
//                        }
//                    
//               
//                       
//                    default:
//                        Text("Error")
//                    }
//                }
                
                Spacer()
                    
                    
                    if showFilters {
                        HStack() {
                            Toggle("Read", isOn: $readFilter)
                            Toggle("Unread", isOn: $unreadFilter)
                        }
                        .padding()
                        .frame(width: 343)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    Spacer()
                
            }
            .navigationBarTitle("dermChat")
            .navigationBarItems(trailing: NavigationLink(destination: ProfileCompletedView(), label: {
                Image(systemName: "person.crop.circle")
                    .font(.title3)
                    .foregroundColor(Color("PrimaryColor"))
            }))
        }
        .searchable(text: $searchTerm)
    }
}


#Preview {
    MessageView()
}
