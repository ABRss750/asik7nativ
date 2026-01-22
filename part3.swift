import SwiftUI

struct ContentView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var ageText: String = ""
    @State private var showError: Bool = false
    @State private var statusMessage: String = ""
    
    private var isEmailValid: Bool{
        email.contains("@") && email.contains(".")
    }
    private var isAgeValid: Bool{
        if let age = Int(ageText){
            return age > 0
        }
        return false
    }
    private var isFormValid: Bool{
        !name.isEmpty && !email.isEmpty && isEmailValid && isAgeValid
    }
    
    var body: some View{
        NavigationStack{
            Form{
                Section(header: Text("User Information")){
                    TextField("Enter your name", text: $name)
                    
                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    TextField("Enter your age", text: $ageText)
                        .keyboardType(.numberPad)
                    
                    if showError{
                        Text("Please enter valid name,email and age")
                            .foregroundColor(.red)
                    }
                    Button("Save"){
                        if isFormValid{
                            showError = false
                            
                            let profile = UserProfile(
                                name: name,
                                email: email,
                                age: Int(ageText)!
                            )
                            profile.save()
                            statusMessage = "Profile Saved!"
                        } else{
                            showError = true
                            statusMessage = ""
                        }
                    }
                    .disabled(!isFormValid)
                    Button("Clear"){
                        UserProfile.clear()
                        name = ""
                        email = ""
                        ageText = ""
                        statusMessage = "Profile cleared"
                    }
                    if !statusMessage.isEmpty{
                        Text(statusMessage)
                            .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("Profile form")
            .onAppear{
                if let savedProfile = UserProfile.load(){
                    name = savedProfile.name
                    email = savedProfile.email
                    ageText = String(savedProfile.age)
                    statusMessage = "Status loaded from UserDefaults"
                }
            }
        }
    }
}

struct UserProfile: Codable{
    var name: String
    var email: String
    var age: Int
    
    private static let userDefaultsKey = "user_Profile"
    func save(){
        if let data = try? JSONEncoder().encode(self){
            UserDefaults.standard.set(data,forKey: UserProfile.userDefaultsKey)
            print("Profile saved to userDefaults")
        }
    }
    static func load() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let profile = try? JSONDecoder().decode(UserProfile.self,from: data) else{
            return nil
        }
        return profile
    }
    static func clear(){
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
