//
//  SpeakerListViewController.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 9/20/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import UIKit

class SpeakerListViewController: UITableViewController {
    var viewModel: SpeakerListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.refresh {
            self.tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSpeakers()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! SpeakerCell
        cell.viewModel = viewModel.speakerViewModelAtIndex(indexPath.row)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as! SpeakerViewController
        let index = self.tableView.indexPathForSelectedRow!.row
        viewController.viewModel = viewModel.speakerViewModelAtIndex(index).speakerDetailsViewModel
    }
}

class SpeakerCell: UITableViewCell {
    var viewModel: SpeakerViewModelProtocol! {
        didSet {
            viewModel.speakerName.bindAndFire { self.textLabel?.text = $0 }
        }
    }
}