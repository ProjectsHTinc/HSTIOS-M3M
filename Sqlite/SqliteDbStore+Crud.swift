//
//  SqliteDbStore+CrudOperations.swift
//  SqliteIntegration
//
//  Created by Ayush Gupta on 1/20/19.
//  Copyright © 2019 Ayush Gupta. All rights reserved.
//

import Foundation
import SQLite3

extension SqliteDbStore {
    //"INSERT INTO Records (Name, EmployeeID, Designation) VALUES (?,?,?)"
    func create(record: Record) {
        // ensure statements are created on first usage if nil
        guard self.prepareInsertEntryStmt() == SQLITE_OK else { return }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.insertEntryStmt)
        }
        
        //  At some places (esp sqlite3_bind_xxx functions), we typecast String to NSString and then convert to char*,
        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift's sqlite3 bridging. this conversion resolves it.
        
        //Inserting name in insertEntryStmt prepared statement
        if sqlite3_bind_text(self.insertEntryStmt, 1, (record.user_id as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        
        //Inserting employeeID in insertEntryStmt prepared statement
        if sqlite3_bind_text(self.insertEntryStmt, 2, (record.lat as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        
        //Inserting designation in insertEntryStmt prepared statement
        if sqlite3_bind_text(self.insertEntryStmt, 3, (record.lon as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.insertEntryStmt, 4, (record.location as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.insertEntryStmt, 5, (record.dateandtime as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.insertEntryStmt, 6, (record.distance as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.insertEntryStmt, 7, (record.pia_id as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.insertEntryStmt, 8, (record.gps_status as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.insertEntryStmt, 9, (record.server_id as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.insertEntryStmt, 10, (record.sync_status as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        
        //executing the query to insert values
        let r = sqlite3_step(self.insertEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(insertEntryStmt) \(r)")
            return
        }
    }
    
    //"SELECT * FROM Records WHERE EmployeeID = ? LIMIT 1"
    func read(sync_status: String) throws -> Record {
        // ensure statements are created on first usage if nil
        guard self.prepareReadEntryStmt() == SQLITE_OK else { throw SqliteError(message: "Error in prepareReadEntryStmt") }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.readEntryStmt)
        }
        
        //  At some places (esp sqlite3_bind_xxx functions), we typecast String to NSString and then convert to char*,
        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift's sqlite3 bridging. this conversion resolves it.
        
        //Inserting employeeID in readEntryStmt prepared statement
        
        if sqlite3_bind_text(self.readEntryStmt, 1, (sync_status as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(readEntryStmt)")
            throw SqliteError(message: "Error in inserting value in prepareReadEntryStmt")
        }
        
        //executing the query to read value
        if sqlite3_step(readEntryStmt) != SQLITE_ROW {
            logDbErr("sqlite3_step COUNT* readEntryStmt:")
            throw SqliteError(message: "Error in executing read statement")
        }
        
        return Record(user_id: String(cString: sqlite3_column_text(readEntryStmt, 1)),
                      lat: String(cString: sqlite3_column_text(readEntryStmt, 2)),
                      lon: String(cString: sqlite3_column_text(readEntryStmt, 3)),location: String(cString: sqlite3_column_text(readEntryStmt, 4)),dateandtime: String(cString: sqlite3_column_text(readEntryStmt, 5)),distance: String(cString: sqlite3_column_text(readEntryStmt, 6)),pia_id: String(cString: sqlite3_column_text(readEntryStmt, 7)),gps_status: String(cString: sqlite3_column_text(readEntryStmt, 8)),server_id: String(cString: sqlite3_column_text(readEntryStmt, 9)),sync_status: String(cString: sqlite3_column_text(readEntryStmt, 10)))
    }
    
    //"UPDATE Records SET Name = ?, Designation = ? WHERE EmployeeID = ?"
    func update(record: Record) {
        // ensure statements are created on first usage if nil
        guard self.prepareUpdateEntryStmt() == SQLITE_OK else { return }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.updateEntryStmt)
        }
        
        //  At some places (esp sqlite3_bind_xxx functions), we typecast String to NSString and then convert to char*,
        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift's sqlite3 bridging. this conversion resolves it.
        
        //Inserting name in updateEntryStmt prepared statement
        
        if sqlite3_bind_text(self.updateEntryStmt, 1, (record.sync_status as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(updateEntryStmt)")
            return
        }
        
        
        
        //executing the query to update values
        let r = sqlite3_step(self.updateEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(updateEntryStmt) \(r)")
            return
        }
    }
    
    //"DELETE FROM Records WHERE EmployeeID = ?"
    func delete(record: Record) {
        // ensure statements are created on first usage if nil
        guard self.prepareDeleteEntryStmt() == SQLITE_OK else { return }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.deleteEntryStmt)
        }
        
        //  At some places (esp sqlite3_bind_xxx functions), we typecast String to NSString and then convert to char*,
        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift's sqlite3 bridging. this conversion resolves it.
        
        //Inserting name in deleteEntryStmt prepared statement
        if sqlite3_bind_text(self.deleteEntryStmt, 1, (record.user_id as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(deleteEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.deleteEntryStmt, 2, (record.lat as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(deleteEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.deleteEntryStmt, 3, (record.lon as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(deleteEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.deleteEntryStmt, 4, (record.location as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(deleteEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.deleteEntryStmt, 5, (record.dateandtime as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(deleteEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.deleteEntryStmt, 6, (record.distance as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(deleteEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.deleteEntryStmt, 7, (record.pia_id as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(deleteEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.deleteEntryStmt, 8, (record.gps_status as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(deleteEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.deleteEntryStmt, 9, (record.server_id as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(deleteEntryStmt)")
            return
        }
        
        if sqlite3_bind_text(self.deleteEntryStmt, 10, (record.sync_status as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(deleteEntryStmt)")
            return
        }
        
        
        //executing the query to delete row
        let r = sqlite3_step(self.deleteEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(deleteEntryStmt) \(r)")
            return
        }
    }
    
    // INSERT/CREATE operation prepared statement
    func prepareInsertEntryStmt() -> Int32 {
        guard insertEntryStmt == nil else { return SQLITE_OK }
        let sql = "INSERT INTO Create_location_store_data (user_id, lat, lon, location, dateandtime, distance, pia_id, gps_status, server_id, sync_status) VALUES (?,?,?,?,?,?,?,?,?,?)"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &insertEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare insertEntryStmt")
        }
        return r
    }
    
    // READ operation prepared statement
    func prepareReadEntryStmt() -> Int32 {
        guard readEntryStmt == nil else { return SQLITE_OK }
        let sql = "SELECT * FROM Create_location_store_data WHERE sync_status = ?"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &readEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare readEntryStmt")
        }
        return r
    }
    
    // UPDATE operation prepared statement
    func prepareUpdateEntryStmt() -> Int32 {
        guard updateEntryStmt == nil else { return SQLITE_OK }
        let sql = "UPDATE Create_location_store_data SET sync_status = ? WHERE sync_status = ?"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &updateEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare updateEntryStmt")
        }
        return r
    }
    
    // DELETE operation prepared statement
    func prepareDeleteEntryStmt() -> Int32 {
        guard deleteEntryStmt == nil else { return SQLITE_OK }
        let sql = "DELETE FROM Create_location_store_data"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &deleteEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare deleteEntryStmt")
        }
        return r
    }
}
