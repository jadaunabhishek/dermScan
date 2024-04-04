//
//  CaseDetailsView.swift
//  dermScan - Patients
//
//  Created by Abhishek Jadaun on 09/03/24.
//

import SwiftUI

struct CaseDetailsView: View {
    var caseInfo : AllCasesUser
    
    var circleColor: String {
        switch caseInfo.riskLevel {
        case "Low risk":
            return "greenCircle"
        case "Medium risk":
            return "orangeCircle"
        case "High risk":
            return "redCircle"
        default:
            return ""
        }
    }
    
    @ObservedObject private var viewModelCases = AllCasesViewModel()
    
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    HStack {
                        if let imageURL = caseInfo.imageURL {
                            AsyncImage(url: caseInfo.imageURL) { phase in
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
                                    Text("Error: \(error.localizedDescription)")
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
                                Text(caseInfo.classType.capitalized)
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Text(caseInfo.status)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .padding(8)
                                    .background(caseInfo.status == "COMPLETE" ? Color.green.opacity(0.4) : Color.gray.opacity(0.4))
                                    .cornerRadius(10)
                            }
                            
                            HStack {
                                Image(circleColor)
                                let precision = String(format: "%.1f%%", caseInfo.confidence * 100)
                                Text("\(caseInfo.riskLevel) (\(precision))")
                                    .font(.caption)
                            }
                            
                            HStack {
                                Image(systemName: "calendar")
                                Text(caseInfo.formattedDate)
                                    .font(.caption)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(5)
                    .background(Color.gray.opacity(0.1))
                    
                    HStack {
                        HStack{
                            VStack{
                                HStack{
                                    Text("Recommendation")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .padding(.bottom, 3)
                                    Spacer()
                                }
                                HStack{
                                    Text("Since your case is pending, please consult a doctor for an accurate diagnosis and prescription by tapping 'Consult'.")
                                        .font(.caption)
                                    Spacer()
                                }
                            }
                            .padding()
                            Image(systemName: "exclamationmark.square.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.red)
                                .padding([.leading, .trailing])
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2) // Add shadow directly
                    .padding()
                    
                    VStack{
                        HStack {
                            NavigationLink(destination: AddDoctorView(scanID: caseInfo.scanID).toolbar(.hidden, for: .tabBar)){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.white)
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                        .frame(height: 125)
                                        .frame(width: 160)
                                    VStack{
                                        Image("bookDoctor")
                                        Text("Consult")
                                    }
                                }
                                .padding(10)
                            }
                            
                            NavigationLink(destination: DiseaseDescription(predictionClass: caseInfo.classType, Confidence: Float(caseInfo.confidence))){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.white)
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                        .frame(height: 125)
                                        .frame(width: 160)
                                    VStack{
                                        Image("caseDescription")
                                        Text("Description")
                                    }
                                }
                                .padding(10)
                            }
                        }
                        
                        HStack {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white)
                                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                    .frame(height: 125)
                                    .frame(width: 160)
                                VStack{
                                    Image("casePhotos")
                                    Text("Photos")
                                }
                            }
                            .padding(10)
                            
                            Button {
                                viewModelCases.updateCaseStatus(scanID: caseInfo.scanID)
                            } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.white)
                                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                            .frame(height: 125)
                                            .frame(width: 160)
                                        VStack{
                                            Image("Cancel")
                                            Text("Close case")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding(10)
                            }
                        }
                    }
                    Spacer()
                    
                }
            }
            .navigationBarTitle("Case Details", displayMode: .inline)
        }
    }
}

#Preview {
    CaseDetailsView(caseInfo: AllCasesUser(userID: "34343", scanID: "353", classType: "nodules", confidence: 0.98, riskLevel: "High risk", formattedDate: "09 March 2024", status: "PENDING", imageURL: URL(string: "adjfakld")))
}
