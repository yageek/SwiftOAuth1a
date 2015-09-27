//
//  NSURL.swift
//  SwiftOAuth1a
//
//  Created by Yannick Heinrich on 17/06/15.
//  Copyright © 2015 yageek. All rights reserved.
//

import Foundation

extension NSURL {
    
    func baseStringURI() -> String {
        
        let comp = NSURLComponents(URL: self, resolvingAgainstBaseURL: false)!
        
        var baseString = ""
        
        if let scheme = comp.scheme {
            baseString += scheme + "://"
        } else {
            baseString += "http://"
        }
        
        if let host = comp.host {
            baseString += host
        }
        
        
        if let port = comp.port where (comp.scheme == "http" && port != 80) || (comp.scheme == "https" && port != 443) {
            baseString += ":" + port.stringValue
        }
        
        if let path = comp.percentEncodedPath {
            baseString += path

        }
        return baseString
    }
}
