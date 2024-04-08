//
//  HomeView.swift
//  dermShield
//
//  Created by Abhishek Jadaun on 11/12/23.
//

import TipKit
import SwiftUI
import FirebaseAuth
import FirebaseDatabaseInternal
import FirebaseStorage

struct DiscoverView: View {
    @ObservedObject private var viewModelMyPatients = MyPatientsViewModel()
    
    @State private var searchElement: String = ""
    @State private var isEditProfileVisible = false
    @State private var isPopoverPresented = false
    
    
    var tipIdentify = identifyTip()
    var tipProfile = profileTip()
    
    @State private var showAllMyPatients = false
    
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            NavigationView{
                ScrollView {
                    VStack{
                        TipView(tipProfile)
                            .padding([.leading, .trailing, .bottom])
                        VStack{
                            
                            Text("Procedure")
                                .font(.callout)
                                .fontWeight(.light)
                                .frame(maxWidth: 340, alignment: .leading)
                                .padding([.leading, .leading])
                                .navigationBarItems(trailing:
                                                        NavigationLink(destination: ProfileCompletedView(), label: {
                                    Image(systemName: "person.crop.circle")
                                        .font(.title3)
                                        .foregroundColor(Color("PrimaryColor"))
                                }))
                            
                            
                            HStack {
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.green)
                                        .opacity(0.1)
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                    
                                    FeatureView(symbolName: "magnifyingglass", featureTitle: "Identify", backgroundColor: Color.green, descriptionText: "Scan your skin to detect acne and other issues quickly and accurately.")
                                        .padding(10)
                                }
                                .padding(.leading, 5)
                                .padding(.trailing, 5)
                                .padding(.bottom, 5)
                                .popoverTip(tipIdentify)
                                
                                
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.blue).opacity(0.1)
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                        .frame(maxHeight: 125)
                                    FeatureView(symbolName: "person.fill.questionmark", featureTitle: "Diagnose", backgroundColor: Color.blue, descriptionText: "Consult with dermatologists to get professional advice.")
                                        .padding(10)
                                }
                                .padding(.leading, 5)
                                .padding(.trailing, 5)
                                .padding(.bottom, 5)
                                
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.purple).opacity(0.1)
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                        .frame(maxHeight: 125)
                                    FeatureView(symbolName: "pills.fill", featureTitle: "Prescribe", backgroundColor: Color.purple, descriptionText: "Receive prescriptions tailored to your skin's needs.")
                                        .padding(10)
                                }
                                .padding(.leading, 5)
                                .padding(.trailing, 5)
                                .padding(.bottom, 5)
                                
                            }
                            .padding([.leading, .trailing])
                            
                            
                            // start
                            HStack{
                                Text("My Patients")
                                    .font(.callout)
                                    .fontWeight(.light)
                                    .frame(maxWidth: 340, alignment: .leading)
                                
                                
                                
                                Button(action: {
                                    showAllMyPatients.toggle() // Toggle between showing all cases or only the recent one
                                }) {
                                    HStack {
                                        Text(showAllMyPatients ? "See less" : "See more") // Change text based on state
                                            .font(.callout)
                                            .fontWeight(.light)
                                        Image(systemName: showAllMyPatients ? "chevron.up" : "chevron.down") // Change icon based on state
                                    }
                                }
                                .foregroundColor(Color("PrimaryColor"))
                            }
                            .padding(.trailing,22)
                            .padding(.leading, 35)
                            .padding(.top)
                            
                            ScrollView() {
                                LazyVStack {
                                    ForEach(viewModelMyPatients.users.indices.prefix(showAllMyPatients ? 3 : 1), id: \.self) { i in
                                        NavigationLink(
                                            destination: PatientDetailsView(patientData: viewModelMyPatients.users[i]),
                                            label: {
                                                // Your Doctor UI view here
                                                // Customize as needed with doctor data
                                                PatientCard(patientDetails: viewModelMyPatients.users[i])
                                                    .padding(.bottom, 5)
                                                    .padding(.top, 5)
                                            }
                                        )
                                        .buttonStyle(PlainButtonStyle()) // To remove NavigationLink default styling
                                    }
                                }
                            }
                            //end
                            
                            Text("Know more about Acne")
                                .font(.callout)
                                .fontWeight(.light)
                                .frame(maxWidth: 340, alignment: .leading)
                                .padding([.leading, .leading])
                            
                            TabView() {
                                NavigationLink(destination: DiseaseDescription(predictionClass: "nodules", Confidence: 0.9)){
                                    customDiseaseDataBox(imageName: "description1", title: "Nodules", progressValue: 0.9, indicatorColor: Color.brown, risk: "High Risk")
                                        .foregroundColor(.white)
                                        .shadow(color: Color.gray, radius: 0.1)
                                }
                                
                                NavigationLink(destination: DiseaseDescription(predictionClass: "pustules", Confidence: 0.7)){
                                    customDiseaseDataBox(imageName: "description2", title: "Pustules", progressValue: 0.7, indicatorColor: Color.orange, risk: "Medium Risk")
                                        .foregroundColor(.white)
                                }
                                
                                NavigationLink(destination: DiseaseDescription(predictionClass: "papules", Confidence: 0.7)){
                                    customDiseaseDataBox(imageName: "description3", title: "Papules", progressValue: 0.7, indicatorColor: Color.yellow, risk: "Medium Risk")
                                        .foregroundColor(.white)
                                }
                                
                                NavigationLink(destination: DiseaseDescription(predictionClass: "comedone", Confidence: 0.4)){
                                    customDiseaseDataBox(imageName: "description4", title: "Comedone", progressValue: 0.4, indicatorColor: Color.green, risk: "Low Risk")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.bottom)
                            .frame(height: 140)
                            .tabViewStyle(PageTabViewStyle())
                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                        }
                    }
                }
                .navigationBarTitle("Discover")
                .padding(.top, 1)
            }
        }
    }
}


struct FeatureView: View {
    var symbolName: String
    var featureTitle: String
    var backgroundColor: Color
    var descriptionText: String
    
    var body: some View {
        VStack {
            Image(systemName: symbolName)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
                .background(backgroundColor)
                .clipShape(Circle())
                .padding(.bottom, 5)
            Text(featureTitle)
                .font(.caption)
                .bold()
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
    }
}


struct customDiseaseDataBox: View {
    var imageName: String
    var title: String
    var progressValue: Double
    var indicatorColor: Color
    var risk: String
    
    var body: some View {
        HStack {
            Image(imageName)
                .font(.title)
            
            VStack (alignment: .leading){
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                
                HStack {
                    
                    ProgressView(value: progressValue, total: 1.0)
                        .accentColor(Color.white)
                        .frame(width: 100)
                    
                    Text(String(format: "%.1f%%", progressValue * 100))
                        .font(.caption)
                    
                }
                
                HStack{
                    Text(risk)
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                }
            }
            .padding([.leading, .trailing])
            
            VStack {
                HStack {
                    Text("Read")
                        .font(.caption2)
                        .fontWeight(.semibold)
                    
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(Color.white)
                
                Spacer()
            }
        }
        .padding(.leading)
        .padding()
        .background(indicatorColor)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
        .cornerRadius(10) // Adjust the height as needed
    }
}


struct AllPatientUser {
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
    var imageURL: URL? // Added property for imageURL
}

class MyPatientsViewModel: ObservableObject {
    @Published var users = [AllPatientUser]()
    
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        print("Current user \(userID)")
        let databaseRef = Database.database().reference().child("doctors/myPatients/\(userID)")
        
        databaseRef.observe(.value) { snapshot in
            var patients = [AllPatientUser]()
            
            for case let childSnapshot as DataSnapshot in snapshot.children {
                if let userData = childSnapshot.value as? [String: Any] {
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
                       let status = userData["status"] as? String {
                        
                        // Fetch image URL
                        let storageRef = Storage.storage().reference().child("patients/\(userIDPatient)/profilePhoto/image.jpg")
                        storageRef.downloadURL { url, error in
                            if let error = error {
                                print("Error downloading image: \(error)")
                                let patient = AllPatientUser(
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
                                    imageURL: nil // Set imageURL to nil in case of error
                                )
                                patients.append(patient)
                                self.users = patients // Update users array after adding all doctors
                                return
                            }
                            
                            guard let url = url else {
                                print("Error: No URL for image")
                                let patient = AllPatientUser(
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
                                    imageURL: nil // Set imageURL to nil in case of error
                                )
                                patients.append(patient)
                                self.users = patients // Update users array after adding all doctors
                                return
                            }
                            
                            let patient = AllPatientUser(
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
                                imageURL: url // Set imageURL to nil in case of error                                imageURL: url // Set imageURL property
                            )
                            patients.append(patient)
                            self.users = patients // Update users array after adding all patients
                        }
                    }
                }
            }
        }
    }
}

struct PatientCard: View {
    var patientDetails: AllPatientUser
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                .frame(maxHeight: 125)
            HStack {
                
                if let imageURL = patientDetails.imageURL {
                    AsyncImage(url: patientDetails.imageURL) { phase in
                        // Depending on the loading phase, show different views
                        switch phase {
                        case .empty:
                            // Placeholder while loading
                            ProgressView()
                                .frame(width: 80, height: 80)
                                .padding()
                            
                        case .success(let image):
                            // Loaded successfully
                            image
                                .resizable()
                                .cornerRadius(10)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .padding()
                            
                        case .failure(let error):
                            // Error occurred while loading
                            Text("Error")
                        @unknown default:
                            // Handle any future cases
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .cornerRadius(10)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding()
                }
                
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(patientDetails.fullName)
                            .font(.title3)
                            .fontWeight(.medium)
                            .padding(.top)
                        
                        Spacer()
                        
                        Text(patientDetails.status)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text("\(patientDetails.age) Years, \(patientDetails.gender)")
                        .font(.callout)
                        .foregroundColor(.gray)
                    Text(patientDetails.riskLevel)
                        .font(.callout)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                }
                Spacer()
            }
        }
        .padding([.trailing, .leading])
    }
}

#Preview {
    DiscoverView()
}
