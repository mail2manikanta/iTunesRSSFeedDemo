//
//  AlbumDetailViewModel.swift
//  iTunesRSSDemo
//
//  Created by Manikanta Nallabelly on 12/30/19.
//  Copyright © 2019 STANZA. All rights reserved.
//

import Foundation
import UIKit


class AlbumDetailViewModel {
    
    private let album:Album
    let imageRequest:ImageRequest
    
    init(album:Album) {
        self.album = album
        self.imageRequest = ImageRequest(url: album.artURL)
    }
    
    func loadImage(_ completion: @escaping (UIImage) -> Void) {
        imageRequest.load(withCompletion: { (result) in
            if case .success(let image) = result {
                completion(image)
            }
        })
    }
    
    func albumName() -> String {
        return album.name
    }
    
    func iTunesURL() -> URL {
        return album.iTunesURL
    }
    
    func genreDisplayInfo() -> String {
        let genreInformation = album.genres.reduce("") { (genres, genre) -> String in
            var separator = ", "
            if genres.isEmpty == true {
                separator = ""
            }
            return genre.name.isEmpty == false ? genres + "\(separator)\(genre.name)" : genres
        }
        
        return genreInformation
    }
    
    func albumDisplayInfo() -> String {
        return " \(album.name)"
                + "\n \(album.artistName)"
            + "\n \(genreDisplayInfo())"
            + "\n\n \(album.releaseDate.readableDate())"
                + "\n \(album.copyrightInfo ?? "")"
    }
}
