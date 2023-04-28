//
//  ArticleListView.swift
//  NewsProject
//
//  Created by Dilan Luhana on 4/23/23.
//

import SwiftUI

struct ArticleListView: View {
    enum sortBy: String, CaseIterable {
        case relevancy, popularity
        case publishedAt = "Published At"
    }
    
    @StateObject var newsVM = NewsViewModel()
    @State var sortMethod: sortBy = .relevancy
    @Environment(\.dismiss) private var dismiss
    @State private var isFilterSheet = false
    @State private var textFieldHelp = ""
    @State private var textFieldHelpOn = false
    @State private var textFieldNumHelp = ""
    @State private var textFieldNumHelpOn = false
    @State var pageAmountVar: pageAmount = .ten
    
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
                Text("Select a Keyword")
                    .foregroundColor(.brown)

                HStack {
                    TextField("Input a Keyword", text: $newsVM.keyword)
                        .textFieldStyle(.roundedBorder)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                        .keyboardType(.asciiCapable)
                        .onSubmit {
                            newsVM.urlString = "https://newsapi.org/v2/everything?q=\(newsVM.keyword)&pageSize=20&sortBy=\(sortMethod)&apiKey=dccd693b384349c2b0b63517e967da90"
                            Task {
                                await newsVM.getData()
                            }
                        }
                        .submitLabel(.search)

                    Button {
                        newsVM.urlString = "https://newsapi.org/v2/everything?q=\(newsVM.keyword)&pageSize=20&sortBy=\(sortMethod)&apiKey=dccd693b384349c2b0b63517e967da90"
                        Task {
                            await newsVM.getData()
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.brown)
                            .font(.title2)
                    }
                }
            }
//            VStack(alignment: .leading) {
//                Text("Select Amount of Results")
//                    .foregroundColor(.brown)
//
//                HStack {
//                    Picker("Pick a Sort Method", selection: $pageAmountVar) {
//                        ForEach(pageAmount.allCases, id: \.self) { num in
//                            Text(num.rawValue.capitalized)
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                    .background(.brown)
//
//                    Button {
//                        textFieldNumHelpOn.toggle()
//                        textFieldNumHelp = newsVM.textFieldNumHelpFunc(on: textFieldNumHelpOn)
//                    } label: {
//                        Image(systemName: "questionmark")
//                            .foregroundColor(.brown)
//                            .font(.title2)
//                    }
//                }
//            }
            .padding(.horizontal)
            
            Text(textFieldNumHelp)
                .font(.caption)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("Pick Sorting Method")
                    .foregroundColor(.brown)
                
                
                Picker("Pick a Sort Method", selection: $sortMethod) {
                    ForEach(sortBy.allCases, id: \.self) { method in
                        Text(method.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .background(.brown)
            }
            .padding(.horizontal)
            
            List {
                ForEach(newsVM.articlesArray, id: \.self) { article in
                    LazyVStack(alignment: .leading) {
                        NavigationLink {
                            ArticleView(article: article)
                        } label: {
                            Text(article.title)
                                .font(Font.custom("Times New Roman", size: 18))
                                .foregroundColor(Color("darkBrown"))
                        }
                        .font(.title2)
                    }
                }
                .font(Font.custom("Georgia", size: 15))
                .listStyle(.plain)
                .navigationTitle("Articles")
            }
            .foregroundColor(.brown)
            .toolbar() {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back to Home") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(.brown)
                }

//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        isFilterSheet.toggle()
//                    } label: {
//                        Image(systemName: "slider.horizontal.3")
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .foregroundColor(.white)
//                    .tint(.brown)
//
//                }
            }
            
        }
        .onChange(of: sortMethod, perform: { newValue in
            newsVM.urlString = "https://newsapi.org/v2/everything?q=\(newsVM.keyword)&pageSize=50&sortBy=\(sortMethod)&apiKey=dccd693b384349c2b0b63517e967da90"
            Task {
                await newsVM.getData()
            }
        })
//        .onChange(of: pageAmountVar, perform: { newValue in
//            newsVM.urlString = "https://newsapi.org/v2/everything?q=\(newsVM.keyword)&pageSize=\(pageAmountVar.rawValue)&sortBy=\(sortMethod)&apiKey=dccd693b384349c2b0b63517e967da90"
//            Task {
//                await newsVM.getData()
//            }
//        })
        
        .sheet(isPresented: $isFilterSheet) {
            FilterView()
        }
        .task {
            await newsVM.getData()
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView()
            .environmentObject(NewsViewModel())
    }
}
