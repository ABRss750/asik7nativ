import SwiftUI

struct ContentView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var ageText: String = ""
    @State private var showError: Bool = false
    
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
                            
                            let userProfile = UserProfile(
                                name: name,
                                email: email,
                                age: Int(ageText)!
                            )
                            print("Saved user: \(userProfile)")
                        } else{
                            showError = true
                        }
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Profile form")
        }
    }
}

struct UserProfile: Codable{
    var name: String
    var email: String
    var age: Int
}
