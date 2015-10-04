//
//  PageViewController.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 9/20/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import UIKit
import ThreeSixtyKit

class TalksPageViewController: UIViewController, UIPageViewControllerDataSource {
    var viewModel: TalkListViewModelProtocol!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let pager = segue.destinationViewController as? UIPageViewController else { return }
        pager.dataSource = self
        
        viewModel.refresh {
            pager.setViewControllers([self.pageForIndex(0)], direction: .Forward, animated: false, completion: nil)
        }
    }
    
    func pageForIndex(index: Int) -> PageViewController {
        let page = self.storyboard!.instantiateViewControllerWithIdentifier("page") as! PageViewController
        page.index = index
        page.viewModel = viewModel.talkViewModelAtIndex(index).talkDetailsViewModel
        return page
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let page = viewController as! PageViewController
        let index = page.index - 1
        if index < 0 {
            return nil
        }
        return pageForIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let page = viewController as! PageViewController
        let index = page.index + 1
        if index >= viewModel.numberOfTalks() {
            return nil
        }
        return pageForIndex(index)
    }
}