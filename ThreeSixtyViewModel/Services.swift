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
    NSURLSession.sharedSession().dataTaskWithURL(Endpoint.Talks.URL()) { (data, response, error) -> Void in
        let talkDicts = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! [[String: String]]
        
        dispatch_async(dispatch_get_main_queue()) {
            let talks = talkDicts.map(talkFromDictGenerator(store.managedObjectContext))
            try! store.managedObjectContext.save()
            completion(talks)
        }
    }.resume()
}

func fetchSpeakers(store: Store, completion: (([Speaker]) -> Void)) {
    NSURLSession.sharedSession().dataTaskWithURL(Endpoint.Speakers.URL()) { (data, response, error) -> Void in
        let speakerDicts = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! [[String: AnyObject]]
        
        dispatch_async(dispatch_get_main_queue()) {
            let speakers = speakerDicts.map(speakerFromDictGenerator(store.managedObjectContext))
            try! store.managedObjectContext.save()
            completion(speakers)
        }
    }.resume()
}

func fetchTalk(ID: String, store: Store, completion: ((Talk) -> Void)) {
    NSURLSession.sharedSession().dataTaskWithURL(Endpoint.Talk(ID).URL()) { (data, response, error) -> Void in
        let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! [String: String]
        
        dispatch_async(dispatch_get_main_queue()) {
            let talk = talkFromDictGenerator(store.managedObjectContext)(dict)
            try! store.managedObjectContext.save()
            completion(talk)
        }
    }.resume()
}

func fetchSpeaker(ID: String, store: Store, completion: ((Speaker) -> Void)) {
    NSURLSession.sharedSession().dataTaskWithURL(Endpoint.Speaker(ID).URL()) { (data, response, error) -> Void in
        let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! [String: AnyObject]
        
        dispatch_async(dispatch_get_main_queue()) {
            let speaker = speakerFromDictGenerator(store.managedObjectContext)(dict)
            try! store.managedObjectContext.save()
            completion(speaker)
        }
    }.resume()
}