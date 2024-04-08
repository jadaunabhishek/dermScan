import SwiftUI
import FirebaseDatabaseInternal
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

struct AllCasesUser: Hashable {
    var userID: String
    var scanID: String
    var classType: String
    var confidence: Double
    var riskLevel: String
    var formattedDate: String
    var status: String
    var imageURL: URL? // New property to hold the URL of the image

    init(userID: String, scanID: String, classType: String, confidence: Double, riskLevel: String, formattedDate: String, status: String, imageURL: URL?) {
        self.userID = userID
        self.scanID = scanID
        self.classType = classType
        self.confidence = confidence
        self.riskLevel = riskLevel
        self.formattedDate = formattedDate
        self.status = status
        self.imageURL = imageURL
    }
}

class AllCasesViewModel: ObservableObject {
    @Published var users = [AllCasesUser]()

//    @Published var refreshData = false

    func updateCaseStatus(scanID: String) {
        if let userID = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference().child("patients/allCases/\(userID)/\(scanID)")
            databaseRef.updateChildValues(["status": "COMPLETE"])
//            self.refreshData.toggle()
        }
    }

    func updateCaseStatusToConsulting(scanID: String) {
        if let userID = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference().child("patients/allCases/\(userID)/\(scanID)")
            databaseRef.updateChildValues(["status": "CONSULTING"])
        }
    }

    init() {
        fetchAllCases()
    }

    func fetchAllCases() {
        if let userID = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference().child("patients/allCases/\(userID)")
            let storageRef = Storage.storage().reference()

            let query = databaseRef.queryOrdered(byChild: "scanID")

            query.observe(.value) { snapshot  in
                var cases = [AllCasesUser]()
                var orderedScanIDs = [String]() // Array to maintain the order of scanIDs

                for child in snapshot.children.reversed() {
                    if let childSnapshot = child as? DataSnapshot,
                       let userData = childSnapshot.value as? [String: Any] {
                        if let userID = userData["userID"] as? String,
                           let scanID = userData["scanID"] as? String,
                           let classType = userData["classType"] as? String,
                           let confidence = userData["confidence"] as? Double,
                           let riskLevel = userData["riskLevel"] as? String,
                           let formattedDate = userData["formattedDate"] as? String,
                           let status = userData["status"] as? String {

                            orderedScanIDs.append(scanID) // Keep track of order

                            // Fetch image URL from Storage
                            let imageRef = storageRef.child("patients/\(userID)/AllCases/\(scanID)/image.jpg")
                            imageRef.downloadURL { (url, error) in
                                if let error = error {
                                    print("Error getting download URL: \(error)")
                                    return
                                }

                                // Create AllCasesUser object with imageURL
                                let caseOfUser = AllCasesUser(
                                    userID: userID,
                                    scanID: scanID,
                                    classType: classType,
                                    confidence: confidence,
                                    riskLevel: riskLevel,
                                    formattedDate: formattedDate,
                                    status: status,
                                    imageURL: url
                                )

                                cases.append(caseOfUser)

                                // Check if all cases are fetched
                                if cases.count == snapshot.childrenCount {
                                    // Reorder cases based on original snapshot order
                                    let orderedCases = orderedScanIDs.compactMap { scanID in
                                        cases.first { $0.scanID == scanID }
                                    }
                                    self.users = orderedCases
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CaseView: View {
    @State private var selectedSegment = 0
    @ObservedObject private var viewModelCases = AllCasesViewModel()

    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            NavigationView {
                VStack {
                    Picker(selection: $selectedSegment, label: Text("")) {
                        Text("All").tag(0)
                        Text("Low Risk").tag(1)
                        Text("Medium").tag(2)
                        Text("High").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    ScrollView {
                        switch selectedSegment {
                        case 0:
                            ForEach(viewModelCases.users, id: \.self) { caseDetail in
                                NavigationLink(destination: CaseDetailsView(caseInfo: caseDetail)){
                                    customRiskBox(caseDetails: caseDetail)
                                        .padding(.top, 10)
                                        .foregroundColor(.black)
                                }
                            }
                        case 1:
                            ForEach(viewModelCases.users.filter { $0.riskLevel == "Low risk" }, id: \.self) { caseDetail in
                                NavigationLink(destination: CaseDetailsView(caseInfo: caseDetail)){
                                    customRiskBox(caseDetails: caseDetail)
                                        .padding(.top, 10)
                                        .foregroundColor(.black)
                                }
                            }
                        case 2:
                            ForEach(viewModelCases.users.filter { $0.riskLevel == "Medium risk" }, id: \.self) { caseDetail in
                                NavigationLink(destination: CaseDetailsView(caseInfo: caseDetail)){
                                    customRiskBox(caseDetails: caseDetail)
                                        .padding(.top, 10)
                                        .foregroundColor(.black)
                                }
                            }
                        case 3:
                            ForEach(viewModelCases.users.filter { $0.riskLevel == "High risk" }, id: \.self) { caseDetail in
                                NavigationLink(destination: CaseDetailsView(caseInfo: caseDetail)){
                                    customRiskBox(caseDetails: caseDetail)
                                        .padding(.top, 10)
                                        .foregroundColor(.black)
                                }
                            }
                        default:
                            Text("Error")
                        }
                    }

                    Spacer()
                }
                // use onReceive to refresh the view when the data changes
//                .onReceive(viewModelCases.$refreshData) { _ in
//                    viewModelCases.fetchAllCases()
//                }

                .navigationBarTitle("Case")
                .navigationBarItems(trailing: NavigationLink(destination: ProfileCompletedView(), label: {
                    Image(systemName: "person.crop.circle")
                        .font(.title3)
                        .foregroundColor(Color("PrimaryColor"))
                }))
            }
        }
    }
}

struct CaseView_Previews: PreviewProvider {
    static var previews: some View {
        CaseView()
    }
}
