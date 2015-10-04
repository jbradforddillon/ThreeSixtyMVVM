//
//  Observable.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 9/12/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import Foundation

public class Dynamic<T> {
    
    public typealias Listener = T -> Void
    private var listener: Listener?
    
    public var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
    
    public func bind(listener: Listener?) {
        self.listener = listener
    }
    
    public func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}