//
//  TalkListViewModel.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 10/4/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import Foundation

public class TalkListViewModel: TalkListViewModelProtocol {
    private var talks = [Talk]()
    private let store: Store
    
    public init(store s: Store) {
        store = s
    }
    
    public func refresh(completion: (() -> Void)?) {
        fetchTalks(store) { (newTalks) -> Void in
            self.talks = newTalks
            completion?()
        }
    }
    
    public func numberOfTalks() -> Int {
        return talks.count
    }
    
    public func talkViewModelAtIndex(index: Int) -> TalkViewModelProtocol {
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