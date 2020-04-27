//
//  Record.swift
//  SqliteIntegration
//
//  Created by Ayush Gupta on 1/20/19.
//  Copyright © 2019 Ayush Gupta. All rights reserved.
//

import Foundation

class Record {
    // Name | Employee Id | Designation
    var user_id: String
    var lat: String
    var lon: String
    var location: String
    var dateandtime: String
    var distance: String
    var pia_id: String
    var gps_status: String
    var server_id: String
    var sync_status: String

    
    init(user_id: String, lat: String, lon: String, location: String, dateandtime: String, distance: String, pia_id: String, gps_status: String, server_id: String, sync_status: String)
    {
        self.user_id = user_id
        self.lat = lat
        self.lon = lon
        self.location = location
        self.dateandtime = dateandtime
        self.distance = distance
        self.pia_id = pia_id
        self.gps_status = gps_status
        self.server_id = server_id
        self.sync_status = sync_status

    }
}
