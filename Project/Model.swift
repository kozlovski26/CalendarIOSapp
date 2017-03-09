//
//  Model.swift
//  Project
//
//  Created by admin on 01/01/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit


let notifyMyEventsListUpdate = "com.admin.notifyMyEventsListUpdate"

extension Date {
    
    
    func toFirebase()->Double{
        return self.timeIntervalSince1970 * 1000
    }
    
    static func fromFirebase(_ interval:String)->Date{
        return Date(timeIntervalSince1970: Double(interval)!)
    }
    
    static func fromFirebase(_ interval:Double)->Date{
        if (interval>9999999999){
            return Date(timeIntervalSince1970: interval/1000)
        }else{
            return Date(timeIntervalSince1970: interval)
        }
    }
    
    var stringValue: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
}



class Model {
    
    static let instance = Model()
    
   lazy private var modelSql:ModelSql? = ModelSql()
   lazy private var modelFirebase:ModelFirebase? = ModelFirebase()
 
    
   private init() {
      //  eventsArray = []
    }
    
    
    func addEvents(ev:MyEvents){
        modelFirebase?.addEvents(ev: ev){(error) in
        }
    }
        

    
    
    
    func deleteEvents (name: String){
        MyEvents.deleteEventByName(database: self.modelSql?.database, name: name)
        modelFirebase?.deleteFromFireBase(name: name)
        
     }
    
    
    
    func getAllMyEvents(callback:@escaping ([MyEvents])->Void){
       
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: MyEvents.EV_TABLE)
        
       
        // get all updated records from firebase
        modelFirebase?.getAllMyEvents(lastUpdateDate, callback: { (events) in
         
            //update the local db
            print("got \(events.count) new records from FB")
            var lastUpdate:Date?
            for ev in events{
                ev.addMyEventsToLocalDB(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = ev.lastUpdate
                }else{
                    if lastUpdate!.compare(ev.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = ev.lastUpdate
                    }
                }
            }
            
           
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: MyEvents.EV_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = MyEvents.getAllMyEventsFromLocalDb(database: self.modelSql?.database)
            
            //return the list to the caller
            callback(totalList)
        })
    }
    
    func getAllMyEventsAndObserve(){
        
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: MyEvents.EV_TABLE)
        
        // get all updated records from firebase
        modelFirebase?.getAllMyEventsAndObserve(lastUpdateDate, callback: { (events) in
           
            //update the local db
            print("got \(events.count) new records from FB")
            var lastUpdate:Date?
            for ev in events{
                ev.addMyEventsToLocalDB(database: self.modelSql?.database)
                if lastUpdate == nil{
                    lastUpdate = ev.lastUpdate
                }else{
                    if lastUpdate!.compare(ev.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = ev.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: MyEvents.EV_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = MyEvents.getAllMyEventsFromLocalDb(database: self.modelSql?.database)
            
            //return the list to the observers using notification center
            NotificationCenter.default.post(name: Notification.Name(rawValue:
                notifyMyEventsListUpdate), object:nil , userInfo:["events":totalList])
        })
    }
    
    
   func saveImage(image:UIImage, name:String, callback:@escaping (String?)->Void){
    
        //1. save image to Firebase
        modelFirebase?.saveImageToFirebase(image: image, name: name, callback: {(url) in
        if (url != nil){
                //2. save image localy
                self.saveImageToFile(image: image, name: name)
        }
        //3. notify the user on complete
        callback(url)
        })
    }
        
    
    func getImage(urlStr:String, callback:@escaping (UIImage?)->Void){
    //1. try to get the image from local store
        let url = URL(string: urlStr)
        let localImageName = url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
            }
        else{
        //2. get the image from Firebase
            modelFirebase?.getImageFromFirebase(url: urlStr, callback: { (image) in
                if (image != nil){
                //3. save the image localy
                    self.saveImageToFile(image: image!, name: localImageName)
                }
                //4. return the image to the user
                callback(image)
            })
        }
    }
        

   
    private func saveImageToFile(image:UIImage, name:String){
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
        
   
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
        .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
        
   
    private func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
        
    }
}


