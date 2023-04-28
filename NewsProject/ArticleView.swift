//
//  ArticleView.swift
//  NewsProject
//
//  Created by Dilan Luhana on 4/24/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ArticleView: View {
    @State var article: Article
    @StateObject var newsVM = NewsViewModel()
    @Environment(\.dismiss) private var dismiss
    @State var width = UIScreen.main.bounds.width
    @FirestoreQuery(collectionPath: "articles") var articles: [Article]


    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack {
                    HStack {
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding()
                    
                    HStack {
                        Image(systemName: "newspaper")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 20) {
                        Text(article.title)
                            .font(.title)
                            .bold()
                            .padding(.top, 20)
                        Text(article.description)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .minimumScaleFactor(0.5)
                        
                        Text("Visit the Article At:")
                            .font(.title)
                            .bold()
                            .padding(.top)
                        
                        HStack {
                            Image(systemName: "safari.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(article.url)
                                Text("URL")
                            }
                            .padding(.leading, 20)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(.brown)
                        .cornerRadius(10)
                        
                        HStack {
                            VStack(alignment: .center, spacing: 5) {
                                Text("")
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            let id = await newsVM.saveArticle(article: article)
                            if id != nil {
                                dismiss()
                            } else {
                                print("😡 Did not save")
                            }
                        }
                    } label: {
                        Text("Add to Saved Articles")
                            .bold()
                            .padding(.vertical)
                            .frame(width: width - 50)
                            .clipShape(Capsule())
                    }
                    .tint(.white)
                    .background(.brown)
                    .cornerRadius(15)
                    .padding(.bottom, 25)
                    .disabled(newsVM.disableButton(article: article, articles: articles))

                }
                .zIndex(1)
                
                Circle()
                    .fill(.brown)
                    .frame(width: width + 200, height: width + 285)
                    .padding(.horizontal, -100)
                    .offset(y: -width)
                Circle()
                    .fill(Color("mediumBrown"))
                    .frame(width: width + 200, height: width + 210)
                    .padding(.horizontal, -100)
                    .offset(y: -width)
                Circle()
                    .fill(Color("darkBrown"))
                    .frame(width: width + 200, height: width + 170)
                    .padding(.horizontal, -100)
                    .offset(y: -width)
                
            }
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: Article(title: "Dilan Test Article", description: "The Article that I am using to test", url: "test@article.com", publishedAt: "Time to publish", content: "Wow this is a lot of information about a test article "))
            .environmentObject(NewsViewModel())
    }
}
