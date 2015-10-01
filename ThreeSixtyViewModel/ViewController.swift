//
//  ViewController.swift
//  360ViewModel
//
//  Created by Brad Dillon on 9/8/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var viewController: UIViewController!
    let store = Store()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let navController = self.storyboard?.instantiateViewControllerWithIdentifier("pages") as! UINavigationController
            let viewController = navController.viewControllers.first as! TalksPageViewController
            viewController.viewModel = TalkListViewModel(store: store)
            
            self.viewController = navController
        }
        else {
            let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("tabs") as! UITabBarController
            for navController in tabBarController.viewControllers as! [UINavigationController] {
                if let viewController = navController.viewControllers.first as? SpeakerListViewController {
                    viewController.viewModel = SpeakerListViewModel(store: store)
                }
                if let viewController = navController.viewControllers.first as? TalkListViewController {
                    viewController.viewModel = TalkListViewModel(store: store)
                }
            }
            
            self.viewController = tabBarController
        }
        
        self.viewController.willMoveToParentViewController(self)
        self.addChildViewController(self.viewController)
        self.view.addSubview(self.viewController.view)
        self.viewController.didMoveToParentViewController(self)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.viewController.view]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.viewController.view]))
    }
}

