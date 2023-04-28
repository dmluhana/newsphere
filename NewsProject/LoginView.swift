//
//  LoginView.swift
//  NewsProject
//
//  Created by Dilan Luhana on 4/26/23.
//

// This code assumes Asset catalog has an image file named "logo"
// also assumes that the first View returned after successful login is called "ListView"
// After pasting this, be sure you update the "App" file so that it loads
// LoginView as the first View.
import SwiftUI
import Firebase

struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    @State private var presentSheet = false
    @FocusState private var focusField: Field?
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Newsphere")
                .font(Font.custom("Times New Roman", size: 70))
                .foregroundColor(.white)
                .bold()
                .background() {
                    RoundedRectangle(cornerRadius: 80, style: .continuous)
                        .fill(.brown)
                        .frame(width: 380, height: 100)
                }
                .padding(.bottom)
            
            
            Text("Register or Login Below")
                .font(Font.custom("Times New Roman", size: 20))
                .foregroundColor(.brown)
                .bold()
                .background() {
                    RoundedRectangle(cornerRadius: 80, style: .continuous)
                        .fill(.white)
                        .frame(width: 220, height: 30)
                }
            
            Group {
                    TextField("E-mail", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .focused($focusField, equals: .email) // this field is bound to the .email case
                        .onSubmit {
                            focusField = .password
                        }
                        .onChange(of: email) { _ in
                            enableButtons()
                        }
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password) // this field is bound to the .password case
                    .onSubmit {
                        focusField = nil // will dismiss the keyboard
                    }
                    .onChange(of: password) { _ in
                        enableButtons()
                    }
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            HStack {
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                }
                .tint(.brown)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.white.opacity(0.5), lineWidth: 4)
                }
                .padding(.trailing)

                Button {
                    login()
                } label: {
                    Text("Log In")
                }
                .tint(.brown)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.white.opacity(0.5), lineWidth: 4)
                }
                .padding(.leading)
            }
            .disabled(buttonsDisabled)
            .buttonStyle(.borderedProminent)
            .font(.title2)
            .padding(.top)
            
            Spacer()
        }
        .background() {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .ignoresSafeArea()
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            // if logged in when app runs, navigate to the new screen & skip login screen
            if Auth.auth().currentUser != nil {
                print("🪵 Login Successful!")
                presentSheet = true
            }
        }
        .fullScreenCover(isPresented: $presentSheet) {
            ButtonView()
        }
    }
    
    func enableButtons() {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error { // login error occurred
                print("😡 SIGN-UP ERROR: \(error.localizedDescription)")
                alertMessage = "SIGN-UP ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎 Registration success!")
                presentSheet = true
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error { // login error occurred
                print("😡 LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🪵 Login Successful!")
                presentSheet = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
