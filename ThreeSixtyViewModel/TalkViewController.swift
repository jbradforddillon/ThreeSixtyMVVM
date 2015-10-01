//
//  TalkViewController.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 9/21/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import UIKit

class TalkViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var detailsLabel: UILabel!

    var viewModel: TalkDetailsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.talkTitle.bindAndFire { self.nameLabel.text = $0 }
        viewModel.talkLocation.bindAndFire { self.locationLabel.text = $0 }
        viewModel.talkDate.bindAndFire { self.dateLabel.text = $0 }
        viewModel.talkTime.bindAndFire { self.timeLabel.text = $0 }
        viewModel.talkDescription.bindAndFire { self.detailsLabel.text = $0 }
        
        viewModel.refresh(nil)
    }
}
