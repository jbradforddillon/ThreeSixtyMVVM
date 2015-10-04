//
//  SpeakerList.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 10/4/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import Foundation

public class SpeakerListViewModel: SpeakerListViewModelProtocol {
    private var speakers = [Speaker]()
    private let store: Store
    
    public init(store s: Store) {
        store = s
    }
    
    public func refresh(completion: (() -> Void)?) {
        fetchSpeakers(store) { (newSpeakers) -> Void in
            self.speakers = newSpeakers
            completion?()
        }
    }
    
    public func numberOfSpeakers() -> Int {
        return speakers.count
    }
    
    public func speakerViewModelAtIndex(index: Int) -> SpeakerViewModelProtocol {
        return SpeakerViewModel(store: store, speaker: speakers[index])
    }
}



public class SpeakerViewModel: SpeakerViewModelProtocol {
    private let speaker: Speaker
    private let store: Store
    
    init(store s: Store, speaker sp: Speaker) {
        store = s
        speaker = sp
        
        speakerName.value = sp.name ?? ""
    }
    
    public let speakerName = Dynamic<String>("")
    
    public lazy var speakerDetailsViewModel: SpeakerDetailsViewModelProtocol = {
        let detailsViewModel = SpeakerDetailsViewModel(store: self.store)
        detailsViewModel.speaker = self.speaker
        return detailsViewModel
        }()
}
