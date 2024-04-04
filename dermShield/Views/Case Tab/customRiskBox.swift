//
//  customRiskBox.swift
//  dermScan - Patients
//
//  Created by Abhishek Jadaun on 09/03/24.
//

import SwiftUI

struct customRiskBox: View {
    var caseDetails: AllCasesUser
    
    var circleColor: String {
        switch caseDetails.riskLevel {
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
    
    var riskColor: Color {
        switch caseDetails.riskLevel {
        case "Low risk":
            return Color.green
        case "Medium risk":
            return Color.orange
        case "High risk":
            return Color.red
        default:
            return Color.gray
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                if let imageURL = caseDetails.imageURL {
                    AsyncImage(url: caseDetails.imageURL) { phase in
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
                        Text(caseDetails.classType.capitalized)
                            .font(.callout)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(caseDetails.status)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(8)
                            .background(caseDetails.status == "COMPLETE" ? Color.green.opacity(0.4) : caseDetails.status == "CONSULTING" ? Color.yellow.opacity(0.4) : Color.gray.opacity(0.4))
                            .cornerRadius(10)

                    }
                    
                    HStack {
                        Image(circleColor)
                        let precision = String(format: "%.1f%%", caseDetails.confidence * 100)
                        Text("\(caseDetails.riskLevel) (\(precision))")
                            .font(.caption)
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(caseDetails.formattedDate)
                            .font(.caption)
                    }
                }
                
                Spacer()
            }
        }
        .background(riskColor.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(riskColor, lineWidth: 1)
        )
        .padding([.leading, .trailing])
    }
}

#Preview {
    customRiskBox(caseDetails: AllCasesUser(userID: "232", scanID: "34", classType: "nodules", confidence: 0.878, riskLevel: "High risk", formattedDate: "09 March 2024", status: "PENDING", imageURL: URL(string: "asdkfjasdfkl")))
}
