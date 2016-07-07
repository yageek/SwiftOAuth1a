//
//  ParameterList.swift
//  SwiftOAuth1a
//
//  Created by Yannick Heinrich on 17/06/15.
//  Copyright © 2015 yageek. All rights reserved.
//

import Foundation

typealias ParameterPair = (name: String, value: String?)

public class ParameterList {
    
    var params:[ParameterPair] = []
    
    func addParameters(parameters:[String:String]){
        for (name,value) in parameters {
            self.addParameter(name, value: value)
        }
    }
    
    func addParameter(name:String, value:String? = nil){
        self.params.append((name:name.pcen(), value:value?.pcen()))
    }
    
    func normalizedParameters(joinElement:String = "&", escapeValues:Bool = false) -> String {
        
        let sortedItems = self.params.sort({ q1, q2 in
            if q1.name == q2.name {
                return q1.value < q2.value
            } else {
                return q1.name < q2.name
            }
        })
        
        let joinElements = sortedItems.map { (pair:ParameterPair) -> String in
            var value = pair.value ?? ""
            if escapeValues {
                value = "\"" + value + "\""
            }
            return pair.name + "=" + value
        }

        return joinElements.joinWithSeparator(joinElement)
    }
    
    

    
}

