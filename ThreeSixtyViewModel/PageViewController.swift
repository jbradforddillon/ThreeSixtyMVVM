//
//  PageViewController.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 9/21/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PageViewController: UIViewController {
    var index: Int = 0
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var speakerNameLabel: UILabel!
    @IBOutlet var speakerBioLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var videoContainerView: UIView!
    
    lazy var videoPlayerController = AVPlayerViewController()
    
    var viewModel: TalkDetailsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.videoPlayerController.willMoveToParentViewController(self)
        self.addChildViewController(self.videoPlayerController)
        self.videoContainerView.addSubview(self.videoPlayerController.view)
        self.videoPlayerController.view.translatesAutoresizingMaskIntoConstraints = false
        self.videoContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: ["view": self.videoPlayerController.view]))
        self.videoContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: ["view": self.videoPlayerController.view]))
        self.videoPlayerController.didMoveToParentViewController(self)

        viewModel.talkTitle.bindAndFire { self.nameLabel.text = $0 }
        viewModel.talkLocation.bindAndFire { self.locationLabel.text = $0 }
        viewModel.talkDate.bindAndFire { self.dateLabel.text = $0 }
        viewModel.talkTime.bindAndFire { self.timeLabel.text = $0 }
        viewModel.talkDescription.bindAndFire { self.descriptionLabel.text = $0 }
        
        viewModel.talkStreamURL.bindAndFire {
            if let streamURL = $0 {
                self.videoPlayerController.player = AVPlayer(URL: streamURL)
            }
        }

        viewModel.speakerDetailsViewModel.speakerName.bindAndFire { self.speakerNameLabel.text = $0 }
        viewModel.speakerDetailsViewModel.speakerBio.bindAndFire { self.speakerBioLabel.text = $0 }
        viewModel.speakerDetailsViewModel.speakerProfileImage.bindAndFire { self.profileImageView.image = $0 }
        
        viewModel.refresh(nil)
    }
}