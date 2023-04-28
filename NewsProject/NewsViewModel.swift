//
//  NewsViewModel
//  NewsProject
//
//  Created by Dilan Luhana on 4/23/23.
//

import Foundation
import FirebaseFirestore

@MainActor
class NewsViewModel: ObservableObject {
    @Published var keyword = ""
    @Published var aticle = Article()
    
    struct Returned: Codable {
        var articles: [Article]
        
    }
    
    var urlString = "https://newsapi.org/v2/everything?q=hair&page=1&pageSize=10&apiKey=dccd693b384349c2b0b63517e967da90"
    
    @Published var articlesArray: [Article] = []
    @Published var savedArticles: [Article] = []
    @Published var totalResults = 0
    
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not convert \(urlString) to a URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let returned = try JSONDecoder().decode(Returned.self, from: data)
                print("returned: \(returned)")
                self.articlesArray = returned.articles
            } catch {
                print("😡 JSON ERROR: Could not convert data into JSON \(error)")
            }
        } catch {
            print("😡 ERROR: Could not get data from urlString \(urlString)")
        }
    }
    
    func saveArticle(article: Article) {
        let newArticle = article
        savedArticles.append(newArticle)
    }
    
    func textFieldHelpFunc(on: Bool) -> String {
        if on {
            return "Advanced search is supported here: \n• Surround phrases with quotes for exact match. \n• Prepend words or phrases that must appear with a + symbol. Eg: +bitcoin \n• Prepend words that must not appear with a - symbol. Eg: -bitcoin \n• Alternatively you can use the AND / OR / NOT keywords, and optionally group these with parenthesis. Eg: crypto AND (ethereum OR litecoin) NOT bitcoin."
        } else {
            return ""
        }
    }
    
    func textFieldNumHelpFunc(on: Bool) -> String {
        if on {
            return "The value selected will be the number of articles in the list"
        } else {
            return ""
        }
    }
    
    func saveArticle(article: Article) async -> String? {
        let db = Firestore.firestore()
//        if let id = article.id { // place must already exist, so save
//            do {
//                try await db.collection("articles").document(id).setData(article.dictionary)
//                print("😎 Data updated successfully!")
//                return article.id
//            } catch {
//                print("😡 ERROR: Could not update data in 'articles' \(error.localizedDescription)")
//                return nil
//            }
//        } else { // no id? Then this must be a new student to add
            do {
                let docRef = try await db.collection("articles").addDocument(data: article.dictionary)
                print("🐣 Data added successfully!")
                return docRef.documentID
            } catch {
                print("😡 ERROR: Could not create a new article in 'articles' \(error.localizedDescription)")
                return nil
            }
        //}
    }
    
//    func deleteData(article: Article) async {
//        let db = Firestore.firestore()
//        guard let id = article.id else {
//            print("😡 ERROR: id was nil. This shoudl not have happened.")
//            return
//        }
//
//        do {
//            try await db.collection("articles").document(id).delete()
//            print("🗑️ Document successfully removed")
//            return
//        } catch {
//            print("😡 ERROR: removing document \(error.localizedDescription)")
//            return
//        }
//    }
    
    func disableButton(article: Article, articles: [Article]) -> Bool {
        if articles.firstIndex(where: {$0.title == article.title}) != nil {
            return true
        } else {
            return false
        }
    }
}
