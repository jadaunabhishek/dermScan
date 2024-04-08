import SwiftUI
import FirebaseDatabaseInternal
import Firebase
import FirebaseStorage

struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var gender: String = ""
    @State private var age: String = ""
    @State private var countryOfResidence: String = ""
    @State private var city: String = ""
    @State private var postCode: String = ""
    @State private var nationalId: String = ""
    @State private var nmcNumber: String = ""
    @State private var about: String = ""
    @State private var clinic: String = ""
    @State private var clinicAddress: String = ""
    @State private var workWeekFrom: String = ""
    @State private var workWeekTo: String = ""
    @State private var specialization: String = ""
    
    let countries = ["Select", "India", "Nepal", "USA", "Australia", "Japan"]
    let genders = ["Select", "Male", "Female", "Other"]
    let days = ["Select", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let specializations = ["Select", "Dermatologist"]
    
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage?
    @State private var profileImageURL: URL?
    
    var isSaveButtonDisabled: Bool {
        return name.isEmpty ||
        gender.isEmpty ||
        age.isEmpty ||
        countryOfResidence.isEmpty ||
        city.isEmpty ||
        postCode.isEmpty || about.isEmpty || specialization.isEmpty || clinic.isEmpty || clinicAddress.isEmpty || workWeekFrom.isEmpty || workWeekTo.isEmpty || nationalId.isEmpty || nmcNumber.isEmpty
    }
    
    
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    Spacer()
                    Image(uiImage: selectedImage ?? UIImage(systemName: "person.crop.circle")!)
                        .resizable()
                        .foregroundColor(Color("PrimaryColor"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .padding(.bottom, 1)
                        .padding(.top)
                        .onTapGesture {
                            isImagePickerPresented.toggle()
                        }
                    Spacer()
                }
                
                Form {
                    Section(header: Text("Personal Details")) {
                        TextField("Name", text: $name)
                        
                        Picker("Gender", selection: $gender) {
                            ForEach(genders, id: \.self) { gender in
                                Text(gender)
                            }
                        }
                        
                        TextField("Age", text: $age)
                        
                        Picker("Country Of Residence", selection: $countryOfResidence) {
                            ForEach(countries, id: \.self) { country in
                                Text(country)
                            }
                        }
                        HStack {
                            TextField("City", text: $city)
                            TextField("PostCode", text: $postCode)
                        }
                    }
                    
                    Section(header: Text("Professional Details")) {
                        TextField("About", text: $about)
                        
                        Picker("Specialization", selection: $specialization) {
                            ForEach(specializations, id: \.self) { special in
                                Text(special).tag(special)
                            }
                        }
                        
                        TextField("Clinic Name", text: $clinic)
                        TextField("Clinic Address", text: $clinicAddress)
                        
                        Picker("Working Day", selection: $workWeekFrom) {
                            ForEach(days, id: \.self) { workFrom in
                                Text("From \(workFrom)").tag(workFrom)
                            }
                        }
                        
                        Picker("Working Day", selection: $workWeekTo) {
                            ForEach(days, id: \.self) { workTo in
                                Text("To \(workTo)").tag(workTo)
                            }
                        }
                        
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
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("Save") {
                    saveProfileData()
                }.disabled(isSaveButtonDisabled))
            }
            .background(Color.gray.opacity(0.11))
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: self.$selectedImage)
            }
        }
    }
    
    func saveProfileData() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userProfile = UserProfile(
            userId: userID,
            name: name,
            gender: gender,
            age: age,
            countryOfResidence: countryOfResidence,
            city: city,
            postCode: postCode,
            about: about,
            specialization: specialization,
            clinic: clinic,
            clinicAddress: clinicAddress,
            workWeekFrom: workWeekFrom,
            workWeekTo: workWeekTo,
            nationalID: nationalId,
            nmcNumber: nmcNumber
        )
        
        let databaseRef = Database.database().reference()
        let userPath = "doctors/profile/\(userID)"
        
        databaseRef.child(userPath).setValue(userProfile.dictionaryRepresentation()) { (error, _) in
            if let error = error {
                print("Error saving profile data: \(error)")
            } else {
                print("Profile data saved successfully")
                saveProfileImage()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    
    func saveProfileImage() {
        guard let userID = Auth.auth().currentUser?.uid, let image = selectedImage else {
            return
        }
        
        let storageRef = Storage.storage().reference().child("doctors/profile/\(userID)/profileImage.jpg")
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            storageRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("Error uploading image: \(error)")
                } else {
                    print("Image uploaded successfully")
                    storageRef.downloadURL { (url, error) in
                        if let url = url {
                            profileImageURL = url
                            // Save the image URL to the database if needed
                        }
                    }
                }
            }
        }
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

