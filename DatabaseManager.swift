//
//  DatabaseManager.swift
//  HDCMerchant
//
//  Created by Bhavin_Thummar on 16/05/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class DatabaseManager: NSObject {
    
    static let manager = DatabaseManager()
    
    var dbNoteActive:OpaquePointer? = nil
    
    func createCopyOfDatabaseIfNeeded() {
        
        let bundlePath = Bundle.main.path(forResource: "Track", ofType: ".db")
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let fileManager = FileManager.default
        
        let fullDestPath = URL(fileURLWithPath: destPath).appendingPathComponent("Track.db")
        
        if fileManager.fileExists(atPath: fullDestPath.path) {
            print("Database file is exist")
            print(fileManager.fileExists(atPath: bundlePath!))
        }
        else {
            do {
                try fileManager.copyItem(atPath: bundlePath!, toPath: fullDestPath.path)
                print("Database file created successfully.")
            }
            catch {
                print("\n",error)
            }
        }
        
    }
    
    func openDatabase() {
        
        let dbpath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .last!.appendingPathComponent("Track.db").path
        
        let error = sqlite3_open(dbpath, &dbNoteActive)
        if error != SQLITE_OK
        {
            print("Error while opening : \(error)");
        }
        
    }
    
    func closeDatabase() {
        sqlite3_close(dbNoteActive)
    }
    
    func executeNonSelectQuery(nonSelectQuery: String) -> Bool {
        
        self.openDatabase()
        
        var isExecutionSuccessful: Bool = false
        
        let query_stmt = (nonSelectQuery as NSString).utf8String
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(dbNoteActive, query_stmt, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                isExecutionSuccessful = true
            }
        }
        
        sqlite3_finalize(statement)
        self.closeDatabase()
        return isExecutionSuccessful
    }
    
//    func executeSelectQuery(selectQuery: String , strTableName: String) -> Array<Any> {
//
//        self.openDatabase()
//
//        var resultSet = Array<Any>()
//
//        let query_stmt = (selectQuery as NSString).utf8String
//
//        var statement:OpaquePointer? = nil
//
//        if sqlite3_prepare_v2(dbNoteActive, query_stmt, -1, &statement, nil) == SQLITE_OK
//        {
//            while sqlite3_step(statement) == SQLITE_ROW {
//
//                var intIndex:Int32 = 0
//
//                if strTableName == "FACILITIES" {
//
//                    let facilities:Facilities = Facilities()
//
//                    intIndex = 0
//                    facilities.strFacilitiesId = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    facilities.strFacility = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    facilities.strFirstName = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    facilities.strLastName = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    facilities.strEmail = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    facilities.strPassword = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    facilities.strSalt = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    facilities.strStatus = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    resultSet.append(facilities)
//
//                }
//
//                else if strTableName == "LICENSEACTIVATE" {
//
//                    let licenseActivate:LicenseActivate = LicenseActivate()
//
//                    intIndex = 0
//                    licenseActivate.strId = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strFirstName = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strLastName = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strEmailAddress = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strContactNumber = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strCompanyName = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strActivationKey = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strAddress = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strIosId = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strServerUrl = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strUserDate = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strFacilities = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strCustomerId = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strAssetId = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    licenseActivate.strSupportServerId = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    resultSet.append(licenseActivate)
//
//                }
//
//                else if strTableName == "NOTELISTING" {
//
//                    let noteListing:NoteListing = NoteListing()
//
//                    intIndex = 0
//                    noteListing.strNoteId = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strChecklistStatus = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strVisitorLog = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strTaskTime = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strReviewNotes = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strIsOffline = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strTaskType = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strTagPrivacy = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strTaskAdded = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strNotesType = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strHighlighterValue = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strNotesDescription = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strKeywordIcon = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strNoteTime = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strUserName = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strSignature = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strNotesPin = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strTextColorCut = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strTextColor = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strNoteDate = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strDateAdded = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strUpdateDateTime = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strStrikeUserName = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strStrikeSignature = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strStrikeDateAdded = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strStrikePin = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strReminderTitle = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    noteListing.strReminderTime = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    resultSet.append(noteListing)
//                }
//
//                else if strTableName == "USERLISTING" {
//
//                    let userListing:UserListing = UserListing()
//
//                    intIndex = 0
//                    userListing.strUserId = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    userListing.strUserName = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    userListing.strFirstName = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    userListing.strLastName = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    userListing.strUserPin = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    userListing.strPhoneNumber = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    intIndex = intIndex + 1
//                    userListing.strEmail = String(cString: sqlite3_column_text(statement, intIndex))
//
//                    resultSet.append(userListing)
//                }
//            }
//        }
//
//        sqlite3_finalize(statement)
//
//        self.closeDatabase()
//
//        return resultSet as Array<Any>
//    }
  
}
