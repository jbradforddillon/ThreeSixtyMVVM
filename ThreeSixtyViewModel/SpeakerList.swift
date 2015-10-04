//
//  SpeakerList.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 10/4/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import Foundation

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
