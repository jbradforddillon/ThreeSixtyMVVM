//
//  SpeakerViewController.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 9/21/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import UIKit

class SpeakerViewController: UITableViewController {
    
    enum Section: Int {
        case Header = 0
        case Talks = 1
    }
    
    var viewModel: SpeakerDetailsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        
        viewModel.refresh {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection s: Int) -> Int {
        guard let section = Section(rawValue: s) else { return 0 }
        
        switch section {
        case .Header: return 1
        case .Talks: return viewModel.talkListViewModel.numberOfTalks()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .Header: return headerCellForTableView(tableView)
        case .Talks: return talkCellForTableView(tableView, index: indexPath.row)
        }
    }

    func headerCellForTableView(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Header") as! SpeakerHeaderCell
        cell.viewModel = viewModel
        return cell
    }
    
    func talkCellForTableView(tableView: UITableView, index: Int) -> TalkCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TalkCell
        cell.viewModel = viewModel.talkListViewModel.talkViewModelAtIndex(index)
        return cell
    }
}

class SpeakerHeaderCell: UITableViewCell {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    
    var viewModel: SpeakerDetailsViewModelProtocol! {
        didSet {
            viewModel.speakerName.bindAndFire { self.nameLabel.text = $0 }
            viewModel.speakerBio.bindAndFire { self.bioLabel.text = $0 }
            viewModel.speakerProfileImage.bindAndFire { self.profileImageView.image = $0 }
        }
    }
}
