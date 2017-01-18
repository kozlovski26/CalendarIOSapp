//
//  MyEvents.swift
//  Project
//
//  Created by admin on 01/01/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
class MyEvents{
    //var lastUpdate:Date?
    var title: String?
    var noats: String?
    var time: String?
    var image: UIImage?
    
    init(_ title: String,_ noats: String,_ time: String,_ image: UIImage) {
        self.title=title
        self.noats=noats
        self.time=time
        self.image=image
    }

    
    
    ///DB
//    init(json:Dictionary<String,Any>){
//        title = json["title"]!
//        noats = json["noats"]!
//        time = json["time"]!
//        image = json[image]!
//    }
//    
//    func toFirebase() -> Dictionary<String,Any> {
//        var json = Dictionary<String,Any>()
//        json["title"] = title
//      json["noats"] = noats
//       json["time"] = time
//    //////////json["lastUpdate"] = FIRServerValue..timestamp()
//        return json
//    }
}
