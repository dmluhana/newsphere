//
//  Article.swift
//  NewsProject
//
//  Created by Dilan Luhana on 4/23/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Article: Identifiable, Codable, Hashable {
//    @DocumentID var id: String?
    var id = UUID().uuidString
    //var author = ""
    var title = ""
    var description = ""
    var url = ""
    //var urlToImage = ""
    var publishedAt = ""
    var content = ""
    
    enum CodingKeys: CodingKey {
        case title, description, url, publishedAt, content
    }
    
    var dictionary: [String: Any] {
        return ["title": title, "description": description, "url": url, "publishedAt": publishedAt, "content": content]
    }
}
