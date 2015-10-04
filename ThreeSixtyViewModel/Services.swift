//
//  Service.swift
//  360ViewModel
//
//  Created by Brad Dillon on 9/12/15.
//  Copyright © 2015 POSSIBLE Mobile. All rights reserved.
//

import CoreData

enum Endpoint {
    case Talks
    case Speakers
    case Talk(String)
    case Speaker(String)
    
    func fragment() -> String {
        switch self {
        case .Talks:
            return "talks"
        case .Speakers:
            return "speakers"
        case .Talk(let ID):
            return "talk/\(ID)"
        case .Speaker(let ID):
            return "speaker/\(ID)"
        }
    }
    
    func URL() -> NSURL {
        return NSURL(string: "http://localhost:8080/\(self.fragment())")!
    }
}

func fetchTalks(store: Store, completion: (([Talk]) -> Void)) {
    NSURLSession.sharedSession().startDataTaskWithURL(Endpoint.Talks.URL()) { (data, response, error) -> Void in
        guard let maybe = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as? [[String: String]], talkDicts = maybe else { return }
        
        dispatch_async(dispatch_get_main_queue()) {
            let talks = talkDicts.map(talkFromDictGenerator(store.managedObjectContext))
            try! store.managedObjectContext.save()
            completion(talks)
        }
    }
}

func fetchSpeakers(store: Store, completion: (([Speaker]) -> Void)) {
    NSURLSession.sharedSession().startDataTaskWithURL(Endpoint.Speakers.URL()) { (data, response, error) -> Void in
        guard let maybe = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as? [[String: AnyObject]], speakerDicts = maybe else { return }
        
        dispatch_async(dispatch_get_main_queue()) {
            let speakers = speakerDicts.map(speakerFromDictGenerator(store.managedObjectContext))
            try! store.managedObjectContext.save()
            completion(speakers)
        }
    }
}

func fetchTalk(ID: String, store: Store, completion: ((Talk) -> Void)) {
    NSURLSession.sharedSession().startDataTaskWithURL(Endpoint.Talk(ID).URL()) { (data, response, error) -> Void in
        guard let maybe = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as? [String: String], dict = maybe else { return }
        
        dispatch_async(dispatch_get_main_queue()) {
            let talk = talkFromDictGenerator(store.managedObjectContext)(dict)
            try! store.managedObjectContext.save()
            completion(talk)
        }
    }
}

func fetchSpeaker(ID: String, store: Store, completion: ((Speaker) -> Void)) {
    NSURLSession.sharedSession().startDataTaskWithURL(Endpoint.Speaker(ID).URL()) { (data, response, error) -> Void in
        guard let maybe = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as? [String: AnyObject], dict = maybe else { return }
        
        dispatch_async(dispatch_get_main_queue()) {
            let speaker = speakerFromDictGenerator(store.managedObjectContext)(dict)
            try! store.managedObjectContext.save()
            completion(speaker)
        }
    }
}