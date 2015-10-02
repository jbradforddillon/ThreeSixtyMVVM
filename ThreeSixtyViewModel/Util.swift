//
//  Util.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 10/2/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import UIKit

extension UIView {
    func dumpSubviews() {
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
}