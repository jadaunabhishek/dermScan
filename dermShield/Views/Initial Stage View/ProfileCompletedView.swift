//
//  ProfileCompletedView.swift
//  dermShield
//
//  Created by Abhishek Jadaun on 25/01/24.
//

import SwiftUI
import FirebaseDatabaseInternal
import Firebase
import FirebaseStorage

struct ProfileCompletedView: View {
    
    @State private var isEditing: Bool = false
    @State private var userProfile: UserProfile?
    var profileImageURL: URL?
    @State private var errorMessage: String?
    @State private var profileImage: Image?
    
    var body: some View {
        VStack{
            HStack {
                Spacer()
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .padding(.bottom, 1)
                        .padding(.top)
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .foregroundColor(Color("PrimaryColor"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .padding(.bottom, 1)
                        .padding(.top)
                }
                Spacer()
            }
            Form {
                Section(header: Text("Personal Details")) {
                    if let userProfile = userProfile {
                        HStack {
                            Text("Name ")
                                .foregroundColor(.gray)
                            Text(userProfile.name)
                        }
                        
                        HStack {
                            Text("Gender ")
                                .foregroundColor(.gray)
                            Text(userProfile.gender)
                        }
                        
                        HStack {
                            Text("Age ")
                                .foregroundColor(.gray)
                            Text(userProfile.age)
                        }
                        
                        HStack {
                            Text("City ")
                                .foregroundColor(.gray)
                            Text(userProfile.city)
                        }
                        
                        HStack {
                            Text("Country ")
                                .foregroundColor(.gray)
                            Text(userProfile.countryOfResidence)
                        }
                        
                        HStack {
                            Text("Pin ")
                                .foregroundColor(.gray)
                            Text(userProfile.postCode)
                        }
                        
                    } else {
                        Text("Name")
                        Text("Gender")
                        Text("Age")
                        Text("City")
                        Text("Country Of Residence")
                        Text("PostCode")
                    }
                    
                }
                
                Section(header: Text("Medical History")) {
                    if let userProfile = userProfile {
                        HStack {
                            Text("Skin Diseases ")
                                .foregroundColor(.gray)
                            Text(userProfile.skinDiseases)
                        }
                        HStack {
                            Text("Other Diseases ")
                                .foregroundColor(.gray)
                            Text(userProfile.otherDiseases)
                        }
                        HStack {
                            Text("Allergies ")
                                .foregroundColor(.gray)
                            Text(userProfile.allergies)
                        }
                        HStack {
                            Text("Current Medications ")
                                .foregroundColor(.gray)
                            Text(userProfile.currentMedications)
                        }
                        HStack {
                            Text("Family Medical History ")
                                .foregroundColor(.gray)
                            Text(userProfile.familyMedicalHistory)
                        }
                    } else {
                        Text("Skin Diseases")
                        Text("Other Diseases")
                        Text("Allergies")
                        Text("Current Medications")
                        Text("Family Medical History")
                    }
                }
                
                VStack {
                    Button {
                        UserDefaults.standard.set(false, forKey: "emailLoggedIn")
                        UserDefaults.standard.set(false, forKey: "signIn")
                        let firebaseAuth = Auth.auth()
                        do {
                          try firebaseAuth.signOut()
                        } catch let signOutError as NSError {
                          print("Error signing out: %@", signOutError)
                        }
                        
                    } label: {
                        Text("Log out")
                            .foregroundColor(Color.red)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

            }
            .navigationTitle("Profile") 
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Edit") {
                isEditing.toggle()
            })
            .sheet(isPresented: $isEditing) {
                ProfileView()
            }
        }
        .background(Color.gray.opacity(0.11))
        .onAppear {
            // Fetch user profile data when the view appears
            fetchUserProfile()
            downloadImage()
        }
    }
    func fetchUserProfile() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let databaseRef = Database.database().reference()
        let userPath = "patients/profile/\(userID)"
        
        databaseRef.child(userPath).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String: Any] else {
                return
            }
            
            userProfile = UserProfile(
                name: data["name"] as? String ?? "",
                gender: data["gender"] as? String ?? "",
                age: data["age"] as? String ?? "",
                countryOfResidence: data["countryOfResidence"] as? String ?? "",
                city: data["city"] as? String ?? "",
                postCode: data["postCode"] as? String ?? "",
                skinDiseases: data["skinDiseases"] as? String ?? "",
                otherDiseases: data["otherDiseases"] as? String ?? "",
                allergies: data["allergies"] as? String ?? "",
                currentMedications: data["currentMedications"] as? String ?? "",
                familyMedicalHistory: data["familyMedicalHistory"] as? String ?? ""
            )
        }
    }
    
    func downloadImage() {
        guard let userID = Auth.auth().currentUser else {
            errorMessage = "User not authenticated."
            return
        }

        let storage = Storage.storage() // Accessing storage via Firebase module
        let storageRef = storage.reference()
        let imageRef = storageRef.child("patients/\(userID.uid)/profilePhoto/image.jpg")

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
}

#Preview {
    ProfileCompletedView()
}
