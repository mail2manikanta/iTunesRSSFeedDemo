//
//  AlbumListViewModel.swift
//  iTunesRSSDemo
//
//  Created by Manikanta Nallabelly on 12/28/19.
//  Copyright © 2019 STANZA. All rights reserved.
//

import Foundation

class AlbumListViewModel {
    
    let albumRequest:APIRequest<AlbumsResource> = APIRequest(resource: AlbumsResource())
    var albums:[Album] = [Album]()
    var onErrorHandling:((DataError)->Void)?
    
    func fetchAlbums(completion: @escaping () -> Void) {
    albumRequest.load { [weak self] (result: Result<[Album], DataError>) in
        switch result {
            case .success(let albums):
                self?.albums = albums
                completion()
            case .failure(let error):
                self?.onErrorHandling?(error)
            }
        }
    }
}

//MARK:- Data Source methods
extension AlbumListViewModel {
    
    func entityCount() -> Int {
        self.albums.count
    }
    
    func entityAtIndex(_ indexPath:IndexPath) -> Album {
        albums[indexPath.row]
    }
}
