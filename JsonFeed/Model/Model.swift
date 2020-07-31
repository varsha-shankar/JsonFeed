//  Model.swift
//  JsonFeed
//
//  Created by Varsha Shankar on 30/07/20.
//  Copyright © 2020 Varsha Shankar. All rights reserved.
//
import Foundation

struct Facts: Decodable {
    
    var title: String
    var rows: [Rows]?
}

struct Rows: Decodable {
    var title: String?
    var description: String?
    var imageHref: String?
}
