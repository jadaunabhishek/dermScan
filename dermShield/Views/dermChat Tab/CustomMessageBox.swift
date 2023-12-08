//
//  CustomMessageBox.swift
//  DermShield-DoctorApp
//
//  Created by Himal  on 30/01/24.
//


//  Created by Abhishek Jadaun on 28/01/24.
//

import SwiftUI

struct CustomMessageBox: View {
    let message: AllMessageFromPatient
    
    @State private var timestamp : Date = Date()
    
    var body: some View {
            VStack{
                HStack(spacing: 15) {
                    if let imageURL = message.imageURL {
                        AsyncImage(url: message.imageURL) { phase in
                            // Depending on the loading phase, show different views
                            switch phase {
                            case .empty:
                                // Placeholder while loading
                                ProgressView()
                                    .frame(width: 60, height: 60)
                                    .font(.title)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .padding([.leading, .bottom])
                                    .padding(.bottom, 10)
                                
                            case .success(let image):
                                // Loaded successfully
                                image
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .font(.title)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .padding([.leading, .bottom])
                                    .padding(.bottom, 10)
                                
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
                            .frame(width: 60, height: 60)
                            .font(.title)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding([.leading, .bottom])
                            .padding(.bottom, 10)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(message.fullName)
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text(formatDate(timestamp))
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .padding([.trailing])
                        }
                        
                        HStack{
                            Text("Gender :")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text(message.gender)
                                .font(.callout)
                        }
                        
                        HStack {
                            Text("Body part :")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text(message.bodyPart)
                                .font(.callout)
                            
                        }
                        Divider()
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                    }
                    
                }
                .previewLayout(.sizeThatFits)
                .background(Color.white)
                .cornerRadius(10)
                
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
//}

struct CustomMessageBox_Previews: PreviewProvider {
    static var previews: some View {
        CustomMessageBox(message: AllMessageFromPatient(userIDPatient: "5433322",
                                                        fullName: "Patient",
                                                        gender: "Male",
                                                        age: "20",
                                                        bodyPart: "Face",
                                                        time: "Up to a week",
                                                        symptom: "Bleeding",
                                                        extraSymptom: "Acute Pain", scanID: "4343", classType: "Nodule", confidence: 87.2, riskLevel: "High risk", status: "Consulting", imageURL: URL(string: "dajf")
        )
        
        )
        
        
        
    }
}
