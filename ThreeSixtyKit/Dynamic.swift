//
//  Created by Srdan Rasic on 12/10/14.
//  http://rasic.info/bindings-generics-swift-and-mvvm/
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