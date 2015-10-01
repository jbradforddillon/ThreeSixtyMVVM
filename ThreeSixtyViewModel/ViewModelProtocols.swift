//
//  TalkListViewModel.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 9/12/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import CoreData
import UIKit

protocol Refreshable {
    func refresh(completion: (() -> Void)?)
}

protocol TalkListViewModelProtocol: Refreshable {
    func numberOfTalks() -> Int
    func talkViewModelAtIndex(index: Int) -> TalkViewModelProtocol
}

protocol TalkViewModelProtocol {
    var talkTitle: Dynamic<String> { get }
    var talkDetailsViewModel: TalkDetailsViewModelProtocol { get }
}

protocol TalkDetailsViewModelProtocol: Refreshable {
    var talkTitle: Dynamic<String> { get }
    var talkDescription: Dynamic<String> { get }
    var talkLocation: Dynamic<String> { get }
    var talkDate: Dynamic<String> { get }
    var talkTime: Dynamic<String> { get }
    var speakerDetailsViewModel: SpeakerDetailsViewModelProtocol { get }
}

protocol SpeakerDetailsViewModelProtocol: Refreshable {
    var speakerName: Dynamic<String> { get }
    var speakerBio: Dynamic<String> { get }
    var speakerProfileImage: Dynamic<UIImage?> { get }
    var talkListViewModel: SpeakerTalkListViewModelProtocol { get }
}

protocol SpeakerTalkListViewModelProtocol: TalkListViewModelProtocol {
}

protocol SpeakerListViewModelProtocol: Refreshable {
    func numberOfSpeakers() -> Int
    func speakerViewModelAtIndex(index: Int) -> SpeakerViewModelProtocol
}

protocol SpeakerViewModelProtocol {
    var speakerName: Dynamic<String> { get }
    var speakerDetailsViewModel: SpeakerDetailsViewModelProtocol { get }
}