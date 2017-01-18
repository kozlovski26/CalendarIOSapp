//
//  Model.swift
//  Project
//
//  Created by admin on 01/01/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import Firebase

class Model {
    
    //static let instance = Model()
    static let shareInstance: Model = {
        let instance = Model()
        return instance
    }()
    
  
    public var eventsArray = [MyEvents]()
    
    var events: [MyEvents]
    init() {
        events = [MyEvents]()
        FIRApp.configure()
    }
    
    
    func addEvents(ev:MyEvents){
        events.append(ev)
//        let ref = FIRDatabase.database().reference().child("ev").child(ev.title!)
//        ref.setValue(ev.toFirebase())
    }
    
    
    func deleteStudent (title: String){
        for i in 0..<events.count {
            if events[i].title == title {
                events.remove(at: i)
                return
            }
        }
    }
    
}
