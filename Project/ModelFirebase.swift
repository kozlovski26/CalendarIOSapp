//
//  MyEvents.swift
//  Project
//
//  Created by admin on 01/01/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class ModelFirebase {
    
    
    
    
    init(){
        FIRApp.configure()
    }
    
    
    
    func addEvents(ev:MyEvents, completionBlock:@escaping (Error?)->Void){
        
        let ref = FIRDatabase.database().reference().child("events").child(ev.title)
        ref.setValue(ev.toFirebase())
        ref.setValue(ev.toFirebase()){(error, dbref) in
            completionBlock(error)
        }
    }
    
    
    
    
    func getEventsByTitle(title:String, callback:@escaping (MyEvents)->Void){
        let ref = FIRDatabase.database().reference().child("events").child(title)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let json = snapshot.value as? Dictionary<String,String>
            let ev = MyEvents(json: json!)
            callback(ev)
        })
    }
    
    
    
    
    func deleteFromFireBase(name:String) {
        let ref = FIRDatabase.database().reference().child("events").child(name)
        ref.removeValue()
        
    }
    
    
    
    
    func getAllMyEvents(_ lastUpdateDate:Date? , callback:@escaping ([MyEvents])->Void){
        let handler = {(snapshot:FIRDataSnapshot) in
            var events = [MyEvents]()
            for child in snapshot.children.allObjects{
                if let childData = child as? FIRDataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let ev = MyEvents(json: json)
                        events.append(ev)
                    }
                }
            }
            callback(events)
        }
        
        let ref = FIRDatabase.database().reference().child("students")
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observeSingleEvent(of: .value, with: handler)
        }else{
            ref.observeSingleEvent(of: .value, with: handler)
        }
    }
    
    
    
    
    
    func getAllMyEventsAndObserve(_ lastUpdateDate:Date?, callback:@escaping ([MyEvents])->Void){
        let handler = {(snapshot:FIRDataSnapshot) in
            var events = [MyEvents]()
            for child in snapshot.children.allObjects{
                if let childData = child as? FIRDataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let ev = MyEvents(json: json)
                        events.append(ev)
                    }
                }
            }
            callback(events)
        }
        
        let ref = FIRDatabase.database().reference().child("events")
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observe(FIRDataEventType.value, with: handler)
        }else{
            ref.observe(FIRDataEventType.value, with: handler)
        }
    }

    
    
    
    
    lazy var storageRef = FIRStorage.storage().reference(forURL:
        "gs://project-99d22.appspot.com/")
    
    
    func saveImageToFirebase(image:UIImage, name:(String), callback:@escaping (String?)->Void){
        let filesRef = storageRef.child(name)
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            filesRef.put(data, metadata: nil) { metadata, error in
                if (error != nil) {
                    callback(nil)
                } else {
                    let downloadURL = metadata!.downloadURL()
                    callback(downloadURL?.absoluteString)
                }
            }
        }
    }
    
    
    
    func getImageFromFirebase(url:String, callback:@escaping (UIImage?)->Void){
        let ref = FIRStorage.storage().reference(forURL: url)
        ref.data(withMaxSize: 10000000, completion: {(data, error) in
            if (error == nil && data != nil){
                let image = UIImage(data: data!)
                callback(image)
            }else{
                callback(nil)
            }
        })
    }

    
}

    
    

