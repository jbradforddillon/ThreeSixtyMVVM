//
//  TalkDetails.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 10/4/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import Foundation

class TalkDetailsViewModel: TalkDetailsViewModelProtocol {
    private let talk: Talk
    private let store: Store
    
    init(store s: Store, talk t: Talk) {
        store = s
        talk = t
        
        talkTitle = Dynamic<String>(talk.name ?? "")
        talkDescription = Dynamic<String>(talk.details ?? "")
        talkLocation = Dynamic<String>(talk.location ?? "")
        talkDate = Dynamic<String>("")
        talkTime = Dynamic<String>("")
        talkStreamURL = Dynamic<NSURL?>(nil)
        
        _speakerDetailsViewModel = SpeakerDetailsViewModel(store: s)
        
        if let date = talk.date {
            self.talkDate.value = self.dateFormatter.stringFromDate(date) ?? ""
            self.talkTime.value = self.timeFormatter.stringFromDate(date) ?? ""
        }
    }
    
    func refresh(completion: (() -> Void)?) {
        fetchTalk(talk.identifier!, store: store) { (talk) -> Void in
            self.talkTitle.value = talk.name ?? ""
            self.talkDescription.value = talk.details ?? ""
            self.talkLocation.value = talk.location ?? ""
            
            // TODO: Test code
            self.talkStreamURL.value = NSURL(string: "https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8")
            
            if let date = talk.date {
                self.talkDate.value = self.dateFormatter.stringFromDate(date)
                self.talkTime.value = self.timeFormatter.stringFromDate(date)
            }
            
            self._speakerDetailsViewModel.speaker = talk.speaker
            self._speakerDetailsViewModel.refresh {
                completion?()
            }
        }
    }
    
    let talkTitle: Dynamic<String>
    let talkDescription: Dynamic<String>
    let talkLocation: Dynamic<String>
    let talkDate: Dynamic<String>
    let talkTime: Dynamic<String>
    let talkStreamURL: Dynamic<NSURL?>
    
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
        }()
    
    lazy var timeFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .LongStyle
        return formatter
        }()
    
    private let _speakerDetailsViewModel: SpeakerDetailsViewModel
    var speakerDetailsViewModel: SpeakerDetailsViewModelProtocol {
        return _speakerDetailsViewModel
    }
}
