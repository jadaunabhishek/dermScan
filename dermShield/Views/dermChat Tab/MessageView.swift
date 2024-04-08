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

struct AllMessageFromPatient {
    var userIDPatient: String
    var fullName: String
    var gender: String
    var age: String
    var bodyPart: String
    var time: String
    var symptom: String
    var extraSymptom: String
    var scanID: String
    var classType: String
    var confidence: Double
    var riskLevel: String
    var status: String
    var imageURL: URL?
    
    init(userIDPatient: String, fullName: String, gender: String, age: String, bodyPart: String, time: String, symptom: String, extraSymptom: String, scanID: String, classType: String, confidence: Double, riskLevel: String, status: String, imageURL: URL?) {
        self.userIDPatient = userIDPatient
        self.fullName = fullName
        self.gender = gender
        self.age = age
        self.bodyPart = bodyPart
        self.time = time
        self.symptom = symptom
        self.extraSymptom = extraSymptom
        self.scanID = scanID
        self.classType = classType
        self.confidence = confidence
        self.riskLevel = riskLevel
        self.status = status
        self.imageURL = imageURL
    }
    
}

class AllMessagesViewModel: ObservableObject {
    @Published var users = [AllMessageFromPatient]()
    
    init() {
        fetchAllDoctors()
    }
    
    
    func fetchAllDoctors() {
        if let userID = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference().child("message/requestByPatient/\(userID)")
            let storageRef = Storage.storage().reference()
            
            let query = databaseRef.queryOrdered(byChild: "scanID")
            
            query.observe(.value) { snapshot  in
                var messages = [AllMessageFromPatient]()
                var orderedScanIDs = [String]() // Array to maintain the order of scanIDs
                
                for child in snapshot.children.reversed() {
                    if let childSnapshot = child as? DataSnapshot,
                       let userData = childSnapshot.value as? [String: Any] {
                        if let userIDPatient = userData["userIDPatient"] as? String,
                           let fullName = userData["fullName"] as? String,
                           let gender = userData["gender"] as? String,
                           let age = userData["age"] as? String,
                           let bodyPart = userData["bodyPart"] as? String,
                           let time = userData["time"] as? String,
                           let symptom = userData["symptom"] as? String,
                           let extraSymptom = userData["extraSymptom"] as? String,
                           let scanID = userData["scanID"] as? String,
                            let classType = userData["classType"] as? String,
                            let confidence = userData["confidence"] as? Double,
                            let riskLevel = userData["riskLevel"] as? String,
                            let status = userData["status"] as? String
                        {
                            
                            orderedScanIDs.append(scanID) // Keep track of order
                            
                            
                            // Fetch image URL
                            let imageRef = storageRef.child("patients/\(userIDPatient)/profilePhoto/image.jpg")
                            imageRef.downloadURL { url, error in
                                if let error = error {
                                    print("Error downloading image: \(error)")
                                    // Create AllCasesUser object with imageURL
                                    let mes = AllMessageFromPatient(
                                        userIDPatient: userIDPatient,
                                        fullName: fullName,
                                        gender: gender,
                                        age: age,
                                        bodyPart: bodyPart,
                                        time: time,
                                        symptom: symptom,
                                        extraSymptom: extraSymptom,
                                        scanID: scanID,
                                        classType: classType,
                                        confidence: confidence,
                                        riskLevel: riskLevel,
                                        status: status,
                                        imageURL: url
                                    )
                                    messages.append(mes)
                                    self.users = messages // Update users array after adding all doctors
                                    return
                                }
                                guard let url = url else {
                                    print("Error: No URL for image")
                                    // Create AllCasesUser object with imageURL
                                    let mes = AllMessageFromPatient(
                                        userIDPatient: userIDPatient,
                                        fullName: fullName,
                                        gender: gender,
                                        age: age,
                                        bodyPart: bodyPart,
                                        time: time,
                                        symptom: symptom,
                                        extraSymptom: extraSymptom,
                                        scanID: scanID,
                                        classType: classType,
                                        confidence: confidence,
                                        riskLevel: riskLevel,
                                        status: status,
                                        imageURL: url
                                    )
                                    messages.append(mes)
                                    self.users = messages // Update users array after adding all doctors
                                    return
                                }
                                // Create AllCasesUser object with imageURL
                                let mes = AllMessageFromPatient(
                                    userIDPatient: userIDPatient,
                                    fullName: fullName,
                                    gender: gender,
                                    age: age,
                                    bodyPart: bodyPart,
                                    time: time,
                                    symptom: symptom,
                                    extraSymptom: extraSymptom,
                                    scanID: scanID,
                                    classType: classType,
                                    confidence: confidence,
                                    riskLevel: riskLevel,
                                    status: status,
                                    imageURL: url
                                )
                                
                                messages.append(mes)
                                self.users = messages
                                
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
    
    @ObservedObject private var viewModel = AllMessagesViewModel()
    
    @State private var popUpMessagesuggestion = false
    
    @State private var searchText = ""
    @State private var showFilters = false
    @State private var readFilter = false
    @State private var unreadFilter = false
    
    @State private var userProfile: UserProfile?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $searchText)
                            .frame(height: 40)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showFilters.toggle()
                            }
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .padding(8)
                                .accentColor(Color("PrimaryColor"))
                            
                        }
                    }
                    .padding(.horizontal)
                    .frame(width: 343, height: 40)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .navigationBarTitle("dermChat")
                    .navigationBarItems(trailing: NavigationLink(destination: ProfileCompletedView(), label: {
                        Image(systemName: "person.crop.circle")
                            .font(.title3)
                            .foregroundColor(Color("PrimaryColor"))
                    }))
                    
                    VStack {
                        ForEach(viewModel.users.indices, id: \.self) { i in
                            NavigationLink {
                                MessageSuggestionView(patientDetails: viewModel.users[i])
                            } label: {
                                CustomMessageBox(message: viewModel.users[i])
                                    .padding(.top, 10)
                            }
                        }
                    }
                    .padding(.top)
                    
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
            }
        }
    }
}


#Preview {
    MessageView()
}
