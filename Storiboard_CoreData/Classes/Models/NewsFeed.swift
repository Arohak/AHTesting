//
//  Feed.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import Foundation

struct NewsFeed: Decodable {
    
    let response: Response
}

struct Response: Decodable {
    
    let page: Int
    let total: Int
    let status: String
    let results: [Result]

    public enum CodingKeys: String, CodingKey {
        case page = "pageSize"
        case total
        case status
        case results
    }
}

struct Result: Decodable {
    
    let id: String
    let pillarName: String
    let sectionName: String
    let webTitle: String
    let fields: Field
}

struct Field: Decodable {
    
    let thumbnail: String
}

