//
//  JSONDecodable.swift
//  movile-up-ios
//
//  Created by Marcelo Fabri on 17/04/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import Foundation
import ISO8601DateFormatter

public protocol JSONDecodable {
    static func decode(j: AnyObject) -> Self?
}

struct JSONParseUtils {
    static func parseURL(URLString: String?) -> NSURL? {
        return flatMap(URLString) { NSURL(string: $0) }
    }
    
    static let dateFormatter = ISO8601DateFormatter()
    
    static func parseDate(dateString: String?) -> NSDate? {
        return flatMap(dateString) { dateFormatter.dateFromString($0) }
    }
}