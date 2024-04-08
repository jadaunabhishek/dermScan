//
//  PatientDetailsView.swift
//  dermScan - Doctors
//
//  Created by Abhishek Jadaun on 06/04/24.
//

import SwiftUI

struct PatientDetailsView: View {
    var patientData : AllPatientUser
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    PatientDetailsView(patientData: AllPatientUser(userIDPatient: "1234", fullName: "Shivanshu", gender: "Male", age: "21", bodyPart: "Face", time: "afa", symptom: "af", extraSymptom: "fdsf", scanID: "sdf", classType: "dfs", confidence: 0.65, riskLevel: "df", status: "fdsf"))
}
