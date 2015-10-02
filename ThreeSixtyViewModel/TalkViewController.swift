//
//  TalkViewController.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 9/21/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class TalkViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var playButton: UIBarButtonItem!

    var viewModel: TalkDetailsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.talkTitle.bindAndFire { self.nameLabel.text = $0 }
        viewModel.talkLocation.bindAndFire { self.locationLabel.text = $0 }
        viewModel.talkDate.bindAndFire { self.dateLabel.text = $0 }
        viewModel.talkTime.bindAndFire { self.timeLabel.text = $0 }
        viewModel.talkDescription.bindAndFire { self.detailsLabel.text = $0 }
        
        viewModel.talkStreamURL.bindAndFire {
            self.navigationItem.rightBarButtonItem = ($0 == .None) ? nil : self.playButton
        }
        
        viewModel.refresh(nil)
    }
    
    @IBAction func play() {
        let playerController = AVPlayerViewController()
        playerController.player = AVPlayer(URL: viewModel.talkStreamURL.value!)
        self.presentViewController(playerController, animated: true) {
            playerController.player!.play()
        }
    }
}
