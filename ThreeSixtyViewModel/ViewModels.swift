//
//  TalkListViewModels.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 9/12/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import CoreData
import UIKit

class TalkListViewModel: TalkListViewModelProtocol {
    private var talks = [Talk]()
    private let store: Store
    
    init(store s: Store) {
        store = s
    }

    func refresh(completion: (() -> Void)?) {
        fetchTalks(store) { (newTalks) -> Void in
            self.talks = newTalks
            completion?()
        }
    }
    
    func numberOfTalks() -> Int {
        return talks.count
    }
    
    func talkViewModelAtIndex(index: Int) -> TalkViewModelProtocol {
        return TalkRowViewModel(store: store, talk: talks[index])
    }
}

class TalkRowViewModel: TalkViewModelProtocol {
    private let talk: Talk
    private let store: Store

    init(store s: Store, talk t: Talk) {
        store = s
        talk = t
        talkTitle = Dynamic<String>(talk.name ?? "")
    }
    
    let talkTitle: Dynamic<String>
    
    lazy var talkDetailsViewModel: TalkDetailsViewModelProtocol = {
        TalkDetailsViewModel(store: self.store, talk: self.talk)
    }()
}

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

class SpeakerListViewModel: SpeakerListViewModelProtocol {
    private var speakers = [Speaker]()
    private let store: Store
    
    init(store s: Store) {
        store = s
    }
    
    func refresh(completion: (() -> Void)?) {
        fetchSpeakers(store) { (newSpeakers) -> Void in
            self.speakers = newSpeakers
            completion?()
        }
    }
    
    func numberOfSpeakers() -> Int {
        return speakers.count
    }
    
    func speakerViewModelAtIndex(index: Int) -> SpeakerViewModelProtocol {
        return SpeakerViewModel(store: store, speaker: speakers[index])
    }
}

class SpeakerViewModel: SpeakerViewModelProtocol {
    private let speaker: Speaker
    private let store: Store
    
    init(store s: Store, speaker sp: Speaker) {
        store = s
        speaker = sp

        speakerName.value = sp.name ?? ""
    }
    
    let speakerName = Dynamic<String>("")
    
    lazy var speakerDetailsViewModel: SpeakerDetailsViewModelProtocol = {
        let detailsViewModel = SpeakerDetailsViewModel(store: self.store)
        detailsViewModel.speaker = self.speaker
        return detailsViewModel
    }()
}

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

class SpeakerTalkListViewModel: TalkListViewModel, SpeakerTalkListViewModelProtocol {
    var speaker: Speaker?
    
    override init(store: Store) {
        super.init(store: store)
        self.refresh(nil)
    }
    
    override func refresh(completion: (() -> Void)?) {
        guard let speaker = speaker else {
            completion?()
            return
        }
        
        self.talks = speaker.talks?.allObjects as? [Talk] ?? [Talk]()
        completion?()
    }
}