//
//  Extensions.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 10/4/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import Foundation

extension NSURLSession {
    func startDataTaskWithURL(url: NSURL, completionHandler: ((NSData?, NSURLResponse?, NSError?) -> Void)) {
        self.dataTaskWithURL(url, completionHandler: completionHandler).resume()
    }
}