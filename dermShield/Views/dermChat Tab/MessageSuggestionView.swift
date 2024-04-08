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
import FirebaseStorage

struct MessageSuggestionView: View {
    
    var patientDetails : AllMessageFromPatient
    @Environment(\.presentationMode) var presentationMode
    
    @State private var prescription : String = ""
    @State private var userProfile: UserProfile?
    // variables to store to database
    @State private var physicalAssistance : String = ""
    @State private var givePrescription : String = ""
    @State private var profileImage: Image?
    @State private var errorMessage: String?
    @State private var isShowingImage = false
    
    let assistance = ["Select", "Required", "Not Required"]
    
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Patient's Details")) {
                    HStack {
                        Text("Full Name ")
                            .foregroundColor(.gray)
                        Text(patientDetails.fullName)
                    }
                    
                    HStack {
                        Text("Gender ")
                            .foregroundColor(.gray)
                        Text(patientDetails.gender)
                    }
                    
                    HStack {
                        Text("Age ")
                            .foregroundColor(.gray)
                        Text(patientDetails.age)
                    }
                    
                    HStack {
                        Text("Body Part ")
                            .foregroundColor(.gray)
                        Text(patientDetails.bodyPart)
                    }
                    
                    HStack {
                        Text("Duration ")
                            .foregroundColor(.gray)
                        Text(patientDetails.time)
                    }
                    
                    HStack {
                        Text("Symptoms ")
                            .foregroundColor(.gray)
                        Text("\(patientDetails.symptom) and \(patientDetails.extraSymptom)")
                    }
                    
                }
                
                Section(header: Text("Disease Details")) {
                    HStack {
                        Text("Acne type ")
                            .foregroundColor(.gray)
                        Text(patientDetails.classType.capitalized)
                    }
                    
                    HStack {
                        Text("Confidence ")
                            .foregroundColor(.gray)
                        Text(String(format: "%.1f%%", patientDetails.confidence * 100))
                        
                    }
                    
                    
                    HStack {
                        Text("Risk level ")
                            .foregroundColor(.gray)
                        Text(patientDetails.riskLevel)
                    }
                    
                    HStack {
                        Text("Status ")
                            .foregroundColor(.gray)
                        Text(patientDetails.status.capitalized)
                    }
                }
                
                Section(header: Text("Shared image")) {
                            Button(action: {
                                self.isShowingImage.toggle()
                            }, label: {
                                Text("Tap to view image")
                            })
                        }
                
                Section(header: Text("Physical Assistance")) {
                    HStack {
                        Picker("In-person", selection: $physicalAssistance) {
                            ForEach(assistance, id: \.self) { assistance in
                                Text(assistance)
                                
                            }
                        }
                    }
                    .padding([.leading, .trailing])
                }
                
                Section(header: Text("Prescription")) {
                    TextEditor(text: $givePrescription)
                        .frame(minHeight: 100)
                }
            }
            .onAppear(perform: {
                fetchUserProfile()
                downloadImage()
            })
            .navigationBarTitle("Prescription", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
                saveResultForPrescription(userProfile: userProfile)
            }, label: {
                Text("Save")
                    .foregroundColor(.blue)
            }))
            .overlay(
                VStack {
                    if isShowingImage {
                        if let profileImage = profileImage {
                            VStack {
                                profileImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .cornerRadius(10)
                            .padding()
                        }
                    }
                }
                    .onTapGesture {
                        self.isShowingImage = false
                    }
            )
            Spacer()
        }
    }


    func downloadImage() {
        guard let userID = Auth.auth().currentUser else {
            errorMessage = "User not authenticated."
            return
        }
        print("patient user id : \(patientDetails.userIDPatient)")
        print("patient scan id : \(patientDetails.scanID)")

        let storage = Storage.storage() // Accessing storage via Firebase module
        let storageRef = storage.reference()
        let imageRef =
        storageRef.child("patients/\(patientDetails.userIDPatient)/AllCases/\(patientDetails.scanID)/image.jpg")

        imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            guard let imageData = data, error == nil else {
                self.errorMessage = "Error downloading image: \(error?.localizedDescription ?? "Unknown error")"
                return
            }

            if let uiImage = UIImage(data: imageData) {
                self.profileImage = Image(uiImage: uiImage) // Assign downloaded image
            }
        }
    }

func fetchUserProfile() {
    guard let userID = Auth.auth().currentUser?.uid else {
        return
    }
    
    let databaseRef = Database.database().reference()
    let userPath = "doctors/profile/\(userID)"
    
    databaseRef.child(userPath).observeSingleEvent(of: .value) { (snapshot, error) in
        if let error = error {
            print("Error fetching user profile")
            return
        }
        guard let data = snapshot.value as? [String: Any] else {
            return
        }
        
        userProfile = UserProfile(
            userId: data["userId"] as? String ?? "",
            name: data["name"] as? String ?? "",
            gender: data["gender"] as? String ?? "",
            age: data["age"] as? String ?? "",
            countryOfResidence: data["countryOfResidence"] as? String ?? "",
            city: data["city"] as? String ?? "",
            postCode: data["postCode"] as? String ?? "",
            about: data["about"] as? String ?? "",
            specialization: data["specialization"] as? String ?? "",
            clinic: data["clinic"] as? String ?? "",
            clinicAddress: data["clinicAddress"] as? String ?? "",
            workWeekFrom: data["workWeekFrom"] as? String ?? "",
            workWeekTo: data["workWeekTo"] as? String ?? "",
            nationalID: data["nationalID"] as? String ?? "",
            nmcNumber: data["nmcNumber"] as? String ?? ""
        )
    }
}
    
    func saveResultForPrescription(userProfile: UserProfile?) {
        let userId = Auth.auth().currentUser?.uid
        guard let userProfile = userProfile else {
            print("User profile not available")
            return
        }
        let timestamp = Int(Date().timeIntervalSince1970)
        let scanID = "\(timestamp)"
        
        let userAppointmentData = DoctorPrescriptionSent(
            userID: userId!,
            fullName: userProfile.name,
            gender: userProfile.gender,
            age: userProfile.age,
            physicalAssistance: physicalAssistance,
            givePrescription: givePrescription,
            scanID: patientDetails.scanID
        )
        
        let ref = Database.database().reference()
        let userPath = ref.child("message/prescriptionByDoctor/\(patientDetails.userIDPatient)").childByAutoId()
        
        userPath.setValue(userAppointmentData.dictionaryRepresentation()) { (error, _) in
            if let error = error {
                print("Error saving profile data: \(error)")
            } else {
                print("Profile data saved successfully")
            }
        }
    }
}


struct DoctorPrescriptionSent {
    
    @State private var userProfile: UserProfile?
    
    var userID: String
    var fullName: String
    var gender: String
    var age: String
    var physicalAssistance: String
    var givePrescription: String
    var scanID: String
    
    // Add this method to convert the user profile to a dictionary
    func dictionaryRepresentation() -> [String: Any] {
        return [
            "userID": userID,
            "fullName": fullName,
            "gender": gender,
            "age": age,
            "physicalAssistance": physicalAssistance,
            "givePrescription": givePrescription,
            "scanID": scanID    ]
    }
}

struct MessageSuggestionView_Preview: PreviewProvider {
    static var previews: some View{
        MessageSuggestionView(patientDetails: AllMessageFromPatient(userIDPatient: "434334",
                                                                    fullName: "John Doe",
                                                                    gender: "Male",
                                                                    age: "30",
                                                                    bodyPart: "Head",
                                                                    time: "12:00 PM",
                                                                    symptom: "Headache",
                                                                    extraSymptom: "Fever", scanID: "dfrdfk", classType: "Nodule", confidence: 87.2, riskLevel: "High risk", status: "Consulting", imageURL: URL(string: "sdfk")
                                                                   ))
    }
}
