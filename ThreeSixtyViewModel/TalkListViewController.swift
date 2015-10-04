//
//  TalkListViewController.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 9/20/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import UIKit
import ThreeSixtyKit

class TalkListViewController: UITableViewController {
    var viewModel: TalkListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.refresh { 
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTalks()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TalkCell
        cell.viewModel = viewModel.talkViewModelAtIndex(indexPath.row)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as! TalkViewController
        let index = self.tableView.indexPathForSelectedRow!.row
        viewController.viewModel = viewModel.talkViewModelAtIndex(index).talkDetailsViewModel
    }
}

class TalkCell: UITableViewCell {
    var viewModel: TalkViewModelProtocol! {
        didSet {
            viewModel.talkTitle.bindAndFire { self.textLabel?.text = $0 }
        }
    }
}