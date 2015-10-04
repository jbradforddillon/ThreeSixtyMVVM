//
//  SpeakerDetails.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 10/4/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import UIKit

class SpeakerDetailsViewModel: SpeakerDetailsViewModelProtocol {
    private let store: Store
    var speaker: Speaker? {
        didSet {
            (talkListViewModel as! SpeakerTalkListViewModel).speaker = speaker
            self.refresh(nil)
        }
    }
    
    init(store s: Store) {
        store = s
        
        speakerName = Dynamic<String>("")
        speakerBio = Dynamic<String>("")
        speakerProfileImage = Dynamic<UIImage?>(nil)
    }
    
    func refresh(completion: (() -> Void)?) {
        guard let speaker = speaker else {
            completion?()
            return
        }
        
        fetchSpeaker(speaker.identifier!, store: store) { (speaker) -> Void in
            self.speakerName.value = speaker.name ?? ""
            self.speakerBio.value = speaker.bio ?? ""
            
            if let URLString = speaker.avatarURL, URL = NSURL(string: URLString) {
                NSURLSession.sharedSession().dataTaskWithURL(URL) { (data, response, error) -> Void in
                    guard let data = data, image = UIImage(data: data) else { return }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.speakerProfileImage.value = image
                    }
                    }.resume()
            }
            
            self.talkListViewModel.refresh {
                completion?()
            }
        }
    }
    
    let speakerName: Dynamic<String>
    let speakerBio: Dynamic<String>
    let speakerProfileImage: Dynamic<UIImage?>
    
    lazy var talkListViewModel: SpeakerTalkListViewModelProtocol = {
        SpeakerTalkListViewModel(store: self.store)
        }()
}
