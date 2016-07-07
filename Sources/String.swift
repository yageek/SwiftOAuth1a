//
//  String.swift
//  SwiftOAuth1a
//
//  Created by Yannick Heinrich on 17/06/15.
//  Copyright © 2015 yageek. All rights reserved.
//

import Foundation

extension String {
    func pcen() -> String {
        // swiftlint:disable force_cast
        let characterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        // swiftlint:enable force_cast
        characterSet.removeCharactersInString("!*'();:@&=+$,/?%#[]")
        return stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!
    }
}
