//
//  iTunesRSSDemoTests.swift
//  iTunesRSSDemoTests
//
//  Created by Manikanta Nallabelly on 12/31/19.
//  Copyright © 2019 STANZA. All rights reserved.
//

import XCTest
@testable import iTunesRSSDemo

class iTunesRSSDemoTests: XCTestCase {
    
    override func setUp() {

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReadableDateConversion() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "2019-10-08")
        let dateString = date?.readableDate()
        
        XCTAssert(dateString?.isEmpty == false)
        XCTAssert(dateString == "08 Oct 2019", "Date conversion utility test failed")
    }
    
    func testAlbumListViewModel() {
        let testViewModel = AlbumListViewModel()
        
        guard let url = URL.init(string: "https://is1-ssl.mzstatic.com/image/thumb/Video123/v4/b8/25/f4/b825f4c3-a25f-11e9-95c7-759a04dc9315/pr_source.lsr/200x200bb.png") else {
            XCTAssert(false, "Art icon URL conversion failed")
            return
        }
        
        guard let iTunesURL = URL.init(string: "https://itunes.apple.com/us/movie/ad-astra/id1478332956") else {
            XCTAssert(false, "iTunes URL conversion failed")
            return
        }
        
        
        let albumOne = Album(id: "1479600671",
                           name: "Downtown Abbey",
                           artistName: "Michael Engler",
                           artURL: url,
                           releaseDate: Date(),
                           copyrightInfo: "© 2019 Focus Features. All Rights Reserved.",
                           iTunesURL: iTunesURL,
                           genres: [Genre.init(genreId: "4406", name: "Drama"),
                                    Genre.init(genreId: "4407", name: "History") ])
        
        let albumTwo = Album(id: "1478332956",
                           name: "Ad Astra",
                           artistName: "James Grey",
                           artURL: url,
                           releaseDate: Date(),
                           copyrightInfo: "© 2019 Focus Features. All Rights Reserved.",
                           iTunesURL: iTunesURL,
                           genres: [Genre.init(genreId: "4406", name: "Drama"),
                                    Genre.init(genreId: "4407", name: "History") ])
        
        testViewModel.albums = [albumOne, albumTwo]
        
        XCTAssert(testViewModel.entityCount() == 2, "AlbumListViewModel entity count test failed")
        
        XCTAssert(testViewModel.entityAtIndex(IndexPath.init(row: 0, section: 0)).id == "1479600671",
                  "AlbumListViewModel  entityAtIndex test failed")
    }
    
    func testAlbumDetailViewModel() {
        
        guard let url = URL.init(string: "https://is2-ssl.mzstatic.com/image/thumb/Video123/v4/50/0c/66/500c6640-045d-7ba6-85b3-fa8e352937a0/pr_source.lsr/200x200bb.png") else {
            XCTAssert(false, "Art icon URL conversion failed")
            return
        }
        
        guard let iTunesURL = URL.init(string: "https://itunes.apple.com/us/movie/downton-abbey/id1479600671") else {
            XCTAssert(false, "iTunes URL conversion failed")
            return
        }
        
        
        let album = Album(id: "1479600671",
                           name: "Downtown Abbey",
                           artistName: "Michael Engler",
                           artURL: url,
                           releaseDate: Date(),
                           copyrightInfo: "© 2019 Focus Features. All Rights Reserved.",
                           iTunesURL: iTunesURL,
                           genres: [Genre.init(genreId: "4406", name: "Drama"),
                                    Genre.init(genreId: "4407", name: "History") ])
        
        let testViewModel = AlbumDetailViewModel(album:album)
        
        XCTAssert(testViewModel.albumName() == "Downtown Abbey", "Album name test failed")
        XCTAssert(testViewModel.genreDisplayInfo() == "Drama, History", "Album genre display info test failed")        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
