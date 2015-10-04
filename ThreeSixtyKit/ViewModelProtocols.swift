//
//  TalkListViewModel.swift
//  ThreeSixtyViewModel
//
//  Created by Brad Dillon on 9/12/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import CoreData
import UIKit

public protocol Refreshable {
    func refresh(completion: (() -> Void)?)
}

public protocol TalkListViewModelProtocol: Refreshable {
    var date: NSDate? { get }
    func numberOfTalks() -> Int
    func talkViewModelAtIndex(index: Int) -> TalkViewModelProtocol
}

public protocol TalkViewModelProtocol {
    var talkTitle: Dynamic<String> { get }
    var talkDetailsViewModel: TalkDetailsViewModelProtocol { get }
}

public protocol TalkDetailsViewModelProtocol: Refreshable {
    var talkTitle: Dynamic<String> { get }
    var talkDescription: Dynamic<String> { get }
    var talkLocation: Dynamic<String> { get }
    var talkDate: Dynamic<String> { get }
    var talkTime: Dynamic<String> { get }
    var speakerDetailsViewModel: SpeakerDetailsViewModelProtocol { get }
}

public protocol SpeakerDetailsViewModelProtocol: Refreshable {
    var speakerName: Dynamic<String> { get }
    var speakerBio: Dynamic<String> { get }
    var speakerProfileImage: Dynamic<UIImage?> { get }
    var talkListViewModel: SpeakerTalkListViewModelProtocol { get }
}

public protocol SpeakerTalkListViewModelProtocol: TalkListViewModelProtocol {
}

public protocol SpeakerListViewModelProtocol: Refreshable {
    func numberOfSpeakers() -> Int
    func speakerViewModelAtIndex(index: Int) -> SpeakerViewModelProtocol
}

public protocol SpeakerViewModelProtocol {
    var speakerName: Dynamic<String> { get }
    var speakerDetailsViewModel: SpeakerDetailsViewModelProtocol { get }
}