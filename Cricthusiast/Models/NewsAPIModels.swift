//
//  newsAPIModels.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/18/23.
//

import Foundation

import Foundation

// MARK: - NewsAPIModel
struct NewsAPIModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleModel]
}

// MARK: - Article
struct APIResponse: Codable {
    let articles: [ArticleModel]
}

// MARK: - ArticleModel
struct ArticleModel: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}

//New Categories
enum CategoryList:String, CaseIterable {
    case all, general, business,entertainment,health,science,sports,technology
}
