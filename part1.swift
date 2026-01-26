import SwiftUI

struct ContentView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var showError: Bool = false
    
    private var isEmailValid: Bool{
        email.contains("@") && email.contains(".")
    }

    private var isFormValid: Bool{
        !name.isEmpty && !email.isEmpty && isEmailValid
    }
    
    var body: some View{
        NavigationStack{
            Form{
                Section(header: Text("User Information")){
                    TextField("Enter your name", text: $name)
                    
                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
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
}