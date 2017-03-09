//
//  ModelSql.swift
//  Project
//
//  Created by Noa Fialkov on 21/01/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation


extension String {
    public init?(validatingUTF8 cString: UnsafePointer<UInt8>) {
        if let (result, _) = String.decodeCString(cString, as: UTF8.self,
                                                  repairingInvalidCodeUnits: false) {
            self = result
        }
        else {
            return nil
        }
    }
}


class ModelSql{
    
    var database: OpaquePointer? = nil
    
    init?(){
        let dbFileName = "database2.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return nil
            }
        }
        
        if MyEvents.createTable(database: database) == false{
            return nil
        }
        if LastUpdateTable.createTable(database: database) == false{
            return nil
        }
    }
}
