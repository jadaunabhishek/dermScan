//
//  MyDoctorsProfileView.swift
//  dermScan - Patients
//
//  Created by Abhishek Jadaun on 08/04/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MyDoctorsProfileView: View {
    
    let scanID: String
    var doctor : AllDoctorUser
    
    var body: some View {
        ZStack{
            Color("BgColor").edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack() {
                    // Doctor's card
                    DoctorCard(doctorDetails: doctor)
                        .padding([.top, .bottom])
                    
                    // Address
                    HStack{
                        Text("Address")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding([.leading, .trailing])
                        Spacer()
                    }
                    
                    HStack{
                        Text(doctor.clinicAddress)
                            .font(.callout)
                            .padding([.leading, .trailing])
                        Spacer()
                    }
                    
                    
                    // About
                    HStack{
                        Text("About")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding([.leading, .trailing, .top])
                        Spacer()
                    }
                    
                    HStack{
                        Text(doctor.about.description)
                            .font(.callout)
                            .padding([.leading, .trailing])
                        Spacer()
                    }
                    
                    // "View More" section
                    HStack(spacing: 4) {
                        Text("View More")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryColor"))
                        Button(action: {
                        }) {
                            Image(systemName: "arrow.right.circle")
                                .foregroundColor(Color("PrimaryColor"))
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                        Spacer()
                    }
                    .padding([.trailing, .leading, .bottom])
                }
                
                // Working Time
                VStack(alignment: .leading, spacing: 4) {
                    HStack{
                        Text("Working Time")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding([.leading, .trailing])
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(Color("PrimaryColor"))
                            .font(.callout)
                        HStack{
                            Text("\(doctor.workWeekFrom) - \(doctor.workWeekTo)")
                                .font(.custom("NunitoSans-Regular", size: 14))
                            Spacer()
                        }
                    }
                    .padding([.trailing, .leading])
                }
                
                Spacer()
            }
            .navigationBarTitle("Doctor Profile", displayMode: .inline)
        }
    }
}

#if DEBUG
struct MyDoctorsProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyDoctorsProfileView(scanID: "2323", doctor: AllDoctorUser(
            userId: "12345678",
            name: "Dr. John Doe",
            gender: "Male",
            age: "35",
            countryOfResidence: "USA",
            city: "New York",
            postCode: "10001",
            about: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            specialization: "Cardiologist",
            clinic: "HeartCare Clinic",
            clinicAddress: "123 Main St",
            workWeekFrom: "Monday",
            workWeekTo: "Friday",
            nationalID: "123456789",
            nmcNumber: "NMC12345"
        ))
    }
}
#endif



