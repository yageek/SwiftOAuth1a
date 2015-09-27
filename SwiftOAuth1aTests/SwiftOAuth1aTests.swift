//
//  SwiftOAuth1aTests.swift
//  SwiftOAuth1aTests
//
//  Created by Yannick Heinrich on 27/09/15.
//  Copyright © 2015 yageek. All rights reserved.
//

import XCTest
@testable import SwiftOAuth1a
class ISOTest: XCTestCase {
    
    //See RFC5849: https://tools.ietf.org/html/rfc5849#section-3.4.1.3.2
    func testParameterNormalization() {
        let parameters = ParameterList()
        parameters.addParameter("b5", value: "=%3D")
        parameters.addParameter("a3", value: "a")
        parameters.addParameter("c@")
        parameters.addParameter("a2", value: "r b")
        parameters.addParameter("oauth_consumer_key", value: "9djdj82h48djs9d2")
        parameters.addParameter("oauth_token", value: "kkk9d7dh3k39sjv7")
        parameters.addParameter("oauth_signature_method", value: "HMAC-SHA1")
        parameters.addParameter("oauth_timestamp", value: "137131201")
        parameters.addParameter("oauth_nonce", value: "7d8f3e4a")
        parameters.addParameter("c2")
        parameters.addParameter("a3", value: "2 q")
        
        let expectedString = "a2=r%20b&a3=2%20q&a3=a&b5=%3D%253D&c%40=&c2=&oauth_consumer_key=9dj" +
            "dj82h48djs9d2&oauth_nonce=7d8f3e4a&oauth_signature_method=HMAC-SHA1" +
        "&oauth_timestamp=137131201&oauth_token=kkk9d7dh3k39sjv7"
        
        XCTAssertEqual(parameters.normalizedParameters(), expectedString)
        
    }
    
    
    func testBaseStringURIExample1(){
        let URL = NSURL(string: "http://example.com:80/r%20v/X?id=123")!
        XCTAssertEqual(URL.baseStringURI(), "http://example.com/r%20v/X")
    }
    
    func testBaseStringURIExample2(){
        let URL = NSURL(string: "https://www.example.net:8080/?q=1")!
        XCTAssertEqual(URL.baseStringURI(), "https://www.example.net:8080/")
    }
}
