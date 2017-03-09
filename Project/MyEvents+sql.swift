//
//  MyEvents+sql.swift
//  Project
//
//  Created by Noa Fialkov on 21/01/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation


extension MyEvents{
    
    static let EV_TABLE = "MYEVENTS"
    static let EV_TITLE = "TITLE"
    static let EV_NOTES = "NOTES"
    static let EV_LOCATION = "LOCATION"
    static let EV_TIME = "TIME"
    static let EV_IMAGE_URL = "IMAGE_URL"
    static let ST_LAST_UPDATE = "ST_LAST_UPDATE"
    
   
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + EV_TABLE + " ( " + EV_TITLE + " TEXT PRIMARY KEY, "
            + EV_NOTES + " TEXT, "  + EV_LOCATION + " TEXT, "  + EV_TIME + " TEXT, "
            + EV_IMAGE_URL + " TEXT, " + ST_LAST_UPDATE + " DOUBLE )", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
   
    func addMyEventsToLocalDB(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + MyEvents.EV_TABLE
            + "(" + MyEvents.EV_TITLE + ","
            + MyEvents.EV_NOTES + ","
            + MyEvents.EV_LOCATION + ","
            + MyEvents.EV_TIME + ","
            + MyEvents.EV_IMAGE_URL + ","
            + MyEvents.ST_LAST_UPDATE + ") VALUES (?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let title = self.title.cString(using: .utf8)
            let notes = self.notes?.cString(using: .utf8)
            let location = self.location?.cString(using: .utf8)
            let time = self.time.cString(using: .utf8)
            var imageUrl = "".cString(using: .utf8)
            if self.imageUrl != nil {
                imageUrl = self.imageUrl!.cString(using: .utf8)
            }
            
            sqlite3_bind_text(sqlite3_stmt, 1, title,-1,nil);
            sqlite3_bind_text(sqlite3_stmt,2, notes,-1,nil);
            sqlite3_bind_text(sqlite3_stmt,3, location,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, time,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, imageUrl,-1,nil);
            if (lastUpdate == nil){
                lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 6, lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    
    
    static func getAllMyEventsFromLocalDb(database:OpaquePointer?)->[MyEvents]{
        var events = [MyEvents]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from MYEVENTS;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let title =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let notes =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let location =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let time =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                var imageUrl =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,4))
                //let update =  Double(sqlite3_column_double(sqlite3_stmt,5))
                print("read from filter st: \(title) \(notes) \(location) \(time) \(imageUrl)")
                if (imageUrl != nil && imageUrl == ""){
                    imageUrl = nil
                }
                let event = MyEvents(title!,notes!,location!,time!,imageUrl)
                events.append(event)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return events
    }
    
    static func deleteEventByName(database:OpaquePointer? ,name:String) {
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"DELETE FROM MYEVENTS where TITLE=?;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            sqlite3_bind_text(sqlite3_stmt, 1, name.cString(using: .utf8),-1,nil);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("remove successful")
            }
        }
        
    }

}
