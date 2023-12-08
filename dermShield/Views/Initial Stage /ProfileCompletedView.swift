//
//  ProfileCompletedView.swift
//  dermShield
//
//  Created by Abhishek Jadaun on 25/01/24.
//

import SwiftUI
import FirebaseDatabaseInternal
import Firebase

struct ProfileCompletedView: View {
    
    @State private var isEditing: Bool = false
    @State private var userProfile: UserProfile?
    var profileImageURL: URL?
    
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .foregroundColor(Color("PrimaryColor"))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .padding(.bottom, 1)
                    .padding(.top)
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
                
                Section(header: Text("Professional Details")) {
                    if let userProfile = userProfile {
                        HStack {
                            Text("About ")
                                .foregroundColor(.gray)
                            Text(userProfile.about)
                        }
                        HStack {
                            Text("Specialization ")
                                .foregroundColor(.gray)
                            Text(userProfile.specialization)
                        }
                        HStack {
                            Text("Clinic Name ")
                                .foregroundColor(.gray)
                            Text(userProfile.clinic)
                        }
                        HStack {
                            Text("Clinic Address ")
                                .foregroundColor(.gray)
                            Text(userProfile.clinicAddress)
                        }
                        HStack {
                            Text("Working Day ")
                                .foregroundColor(.gray)
                            Text(userProfile.workWeekFrom)
                        }
                        HStack {
                            Text("Working Day ")
                                .foregroundColor(.gray)
                            Text(userProfile.workWeekTo)
                        }
                        HStack {
                            Text("National ID Card Number ")
                                .foregroundColor(.gray)
                            Text(userProfile.nationalID)
                        }
                        HStack {
                            Text("NMC Number ")
                                .foregroundColor(.gray)
                            Text(userProfile.nmcNumber)
                        }
                    } else {
                        Text("About")
                        Text("Specialization ")
                        Text("Clinic Name ")
                        Text("Clinic Address ")
                        HStack {
                            Text("Working Day ")
                            Text("From")
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Working Day ")
                            Text("To")
                                .foregroundColor(.gray)
                        }
                        Text("National ID Card Number")
                        Text("NMC Number")
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

}

#Preview {
    ProfileCompletedView()
}
