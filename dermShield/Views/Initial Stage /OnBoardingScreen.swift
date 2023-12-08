//
//  OnBoardingScreen.swift
//  dermShield
//
//  Created by Abhishek Jadaun on 28/12/23.
//

import SwiftUI

struct OnBoardingScreen: View {
    @State private var currentPage = 0
    var body: some View {
                VStack{
                    if(currentPage<2){
                        Button(action: {
                            // Action to perform when the button is tapped
                        }) {
                            NavigationLink(destination: SignupView()) {
                                Text("Skip")
                                    .foregroundColor(Color("PrimaryColor"))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding([.leading, .trailing])
                            }
                        }
                    } else{
                        Button(action: {
                            // Action to perform when the button is tapped
                        }) {
                            NavigationLink(destination: SignupView()) {
                                Text("Get Started")
                                    .foregroundColor(Color("PrimaryColor"))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding([.leading, .trailing])
                            }
                        }
                    }
                    
                    TabView(selection: $currentPage) {
                        OnboardingStepView(imageName: "OnBoardScreen5", title: "Are you a dermatologist?", description: "Register yourself in dermShield and experience the whole new dynamics of telemedication. Your application will be processed and approved within 24 hours.").tag(0)
                        
                        OnboardingStepView(imageName: "OnBoardScreen3", title: "Map & Track", description: "Develop a personalized body map and consistently monitor your skin conditions.").tag(1)
                        
                        OnboardingStepView(imageName: "OnBoardScreen4", title: "Your data is safe", description: "Safely archive your case files and medical records.").tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
                .navigationBarHidden(true)
                .padding()
            }
        }

struct OnboardingStepView: View {
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
            
            Text(description)
                .foregroundColor(.gray)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

struct DoctorRegistrationView: View {
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var dateOfBirth = Date()
    @State private var nationalId: String = ""
    @State private var nmcNumber: String = ""

    var body: some View {
        Form {
            Section(header: Text("Personal Details")) {
                TextField("Name", text: $name)
                TextField("Complete address with Pincode", text: $address)
                DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                
            }

            Section(header: Text("Professional Details")) {
                TextField("National ID Card Number", text: $nationalId)
                TextField("NMC Number", text: $nmcNumber)
            }

            Section(header: Text("Document Upload")) {
                Button(action: {
                    // Action to upload National ID Proof
                }) {
                    Label("National ID Proof", systemImage: "square.and.arrow.up")
                        .foregroundColor(Color("PrimaryColor"))
                }

                Button(action: {
                    // Action to upload NMC ID Proof
                }) {
                    Label("NMC ID Proof"
                          , systemImage: "square.and.arrow.up")
                    .foregroundColor(Color("PrimaryColor"))
                }
            }
        }
    }
}

#Preview {
    OnBoardingScreen()
}
