//
//  Album.swift
//  iTunesRSSDemo
//
//  Created by Manikanta Nallabelly on 12/28/19.
//  Copyright © 2019 STANZA. All rights reserved.
//

import Foundation

struct Genre: Decodable {
    let genreId:String
    let name:String
}

struct Album {
    
    typealias ID = String
    
    let id:ID
    let name:String
    let artistName:String
    let artURL:URL
    let releaseDate:Date
    let copyrightInfo:String?
    let iTunesURL:URL
    let genres:[Genre]
}

extension Album: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case artistName
        case artURL = "artworkUrl100"
        case releaseDate
        case copyrightInfo = "copyright"
        case iTunesURL = "url"
        case genres
    }
    
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(ID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        artistName = try container.decode(String.self, forKey: .artistName)
        artURL = try container.decode(URL.self, forKey: .artURL)
        
        let dateString = try container.decode(String.self, forKey: .releaseDate)
        let formatter = DateFormatter.yyyyMMdd
        if let date = formatter.date(from: dateString) {
            self.releaseDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .releaseDate,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
        
        copyrightInfo = try? container.decode(String.self, forKey: .copyrightInfo)
        iTunesURL = try container.decode(URL.self, forKey: .iTunesURL)
        genres = try container.decode([Genre].self, forKey: .genres)
    }
}


struct Results<T:Decodable> {
    let results: [T]
}

extension Results: Decodable {
    private enum CodingKeys: String, CodingKey {
        case feed
        case results
    }
    
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let feedContainer = try container.nestedContainer(keyedBy:CodingKeys.self, forKey: .feed)
        results = try feedContainer.decode([T].self, forKey: .results)
    }
}
