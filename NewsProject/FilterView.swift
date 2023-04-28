//
//  FilterView.swift
//  NewsProject
//
//  Created by Dilan Luhana on 4/27/23.
//

import SwiftUI

struct FilterView: View {
    @StateObject var newsVM = NewsViewModel()
    @State private var textFieldHelp = ""
    @State private var textFieldHelpOn = false
    @State private var textFieldNumHelp = ""
    @State private var textFieldNumHelpOn = false
    @State var pageAmountVar: pageAmount = .ten
    @Environment(\.dismiss) private var dismiss
    
    enum pageAmount: String, CaseIterable {
        case ten = "10"
        case twenty = "20"
        case thirty = "30"
        case fourty = "40"
        case fifty = "50"
        case sixty = "60"
        case seventy = "70"
        case eighty = "80"
        case ninety = "90"
        case hundred = "100"
    }
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Filter Settings")
                    .font(.custom("Times New Roman", size: 35))
                    .foregroundColor(Color("darkBrown"))
                    .padding(.horizontal, 10)
                
                
                HStack {
                    TextField("Enter a Keyword", text: $newsVM.keyword)
                        .textFieldStyle(.roundedBorder)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                    
                    Button {
                        textFieldHelpOn.toggle()
                        textFieldHelp = newsVM.textFieldHelpFunc(on: textFieldHelpOn)
                    } label: {
                        Image(systemName: "questionmark")
                            .foregroundColor(.brown)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                Text(textFieldHelp)
                    .font(.caption)
                    .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("Pick Sorting Method")
                        .foregroundColor(.brown)
                    
                    HStack {
                        Picker("Pick a Sort Method", selection: $pageAmountVar) {
                            ForEach(pageAmount.allCases, id: \.self) { num in
                                Text(num.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(.segmented)
                        .background(.brown)
                        
                        Button {
                            textFieldNumHelpOn.toggle()
                            textFieldNumHelp = newsVM.textFieldNumHelpFunc(on: textFieldNumHelpOn)
                        } label: {
                            Image(systemName: "questionmark")
                                .foregroundColor(.brown)
                                .font(.title2)
                        }
                    }
                }
                .padding(.horizontal)
                
                Text(textFieldNumHelp)
                    .font(.caption)
                    .padding(.horizontal)
                
                    .toolbar() {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                Text("Cancel")
                            }
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(.white)
                            .tint(.brown)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                newsVM.urlString = "https://newsapi.org/v2/everything?q=hair&pageSize=\(pageAmountVar.rawValue)&sortBy=relevancy&apiKey=dccd693b384349c2b0b63517e967da90"
                                Task {
                                    await newsVM.getData()
                                }
                                dismiss()
                            } label: {
                                Text("Save")
                            }
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(.white)
                            .tint(.brown)
                        }
                    }
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
