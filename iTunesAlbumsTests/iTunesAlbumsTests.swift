//
//  iTunesAlbumsTests.swift
//  iTunesAlbumsTests
//
//  Created by Nicholas Reeder on 2/12/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import XCTest
@testable import iTunesAlbums

class iTunesAlbumsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUrlIsReached() {
        
    }
    
    
    func testImageCreation() {
        // given
        let urlString = ""
        
        // when
        let a = Album(imageURL: urlString, artist: "", name: "", genre: [[:]], releaseDate: "", copyrightInfo: "", urlString: "")
        let img = a.getImageFromURL()
        // then
        XCTAssertNotNil(img, "Image exists!")
        
    }

    func testConnectionToiTunes() {
        // given
        let url =
            URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json")
        // 1
        let promise = expectation(description: "Status code: 200")
        
        // when
        let connector = iTunesConnector()
        
        let dataTask = connector.session.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        wait(for: [promise], timeout: 5)
    }

}
