//
//  ButtonView.swift
//  NewsProject
//
//  Created by Dilan Luhana on 4/24/23.
//

import SwiftUI
import Firebase


struct ButtonView: View {
    @State var currentTab: Tab = .home
    @Environment(\.dismiss) private var dismiss
    @AppStorage("currentPage") var currentPage = 1
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        NavigationStack {
            TabView(selection: $currentTab) {
                PresentArticlesView()
                    .tag(Tab.home)
                
                SavedArticesView()
                    .tag(Tab.folder)
                
                WhatsNewsphereView()
                    .tag(Tab.question)
                
            }
            
            CustomTabBar(currentTab: $currentTab)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Sign Out") {
                            do {
                                try Auth.auth().signOut()
                                print("🪵➡️ Log out successful!")
                                dismiss()
                            } catch {
                                print("😡 ERROR: Could not sign out!")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.white)
                        .foregroundColor(.brown)
                    }
                }
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
    }
}
