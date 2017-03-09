//
//  MyEvents.swift
//  Project
//
//  Created by Noa Fialkov on 21/01/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyEvents{
    
    var title: String
    var notes: String?
    var time: String
    var location: String?
    var imageUrl: String?
    var lastUpdate: Date?
    
    
    init(_ title: String,_ notes: String,_ location: String, _ time: String ,_ imageUrl: String? = nil) {
        self.title=title
        self.notes=notes
        self.time=time
        self.location=location
        self.imageUrl=imageUrl
    }

    init(json:Dictionary<String,Any>){
        title = json["title"] as! String
        time  = json["time"] as! String
        notes = json["notes"] as? String
        location = json ["location"] as? String
        if let im = json["imageUrl"] as? String{
            imageUrl = im
        }
        if let ts = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["title"] = title
        json["time"] = time
        json["location"] = location
        json["notes"] = notes
        if (imageUrl != nil){
            json["imageUrl"] = imageUrl!
        }
        json["lastUpdate"] = FIRServerValue.timestamp()
        return json
    }
}
