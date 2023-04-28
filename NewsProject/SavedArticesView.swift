//
//  SavedArticesView.swift
//  NewsProject
//
//  Created by Dilan Luhana on 4/27/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct SavedArticesView: View {
    @FirestoreQuery(collectionPath: "articles") var firestoreArticles: [Article]
    @StateObject var newsVM = NewsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Saved Articles")
                .font(.custom("Times New Roman", size: 35))
                .foregroundColor(Color("darkBrown"))
            
            List {
                ForEach(firestoreArticles) { article in
                    NavigationLink {
                        ArticleView(article: article)
                    } label: {
                        Text(article.title)
                            .foregroundColor(Color("darkBrown"))
                    }
                }
//                .onDelete { indexSet in
//                    guard let index = indexSet.first else {return}
//                    Task {
//                        await newsVM.deleteData(article: firestoreArticles[index])
//                    }
//                }
            }
            .listStyle(.plain)
        }
        .padding()
    }
}

struct SavedArticesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedArticesView()
            .environmentObject(NewsViewModel())
    }
}
