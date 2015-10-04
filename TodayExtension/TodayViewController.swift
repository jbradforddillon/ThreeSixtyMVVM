//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Brad Dillon on 10/4/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import UIKit
import NotificationCenter
import ThreeSixtyKit

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    let viewModel = TalkListViewModel(store: Store())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.date = NSDate()
        
        viewModel.refresh {
            self.tableView.reloadData()
        }
    }
        
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        viewModel.refresh {
            self.tableView.reloadData()
            completionHandler(NCUpdateResult.NewData)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTalks()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TodayCell
        cell.viewModel = viewModel.talkViewModelAtIndex(indexPath.row)
        return cell
    }
}


class TodayCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!

    var viewModel: TalkViewModelProtocol! {
        didSet {
            viewModel.talkTitle.bindAndFire { self.titleLabel.text = $0 }
            viewModel.talkDetailsViewModel.talkDate.bindAndFire { self.timeLabel.text = $0 }
            viewModel.talkDetailsViewModel.talkLocation.bindAndFire { self.locationLabel.text = $0 }
            
            viewModel.talkDetailsViewModel.refresh(nil)
        }
    }
}