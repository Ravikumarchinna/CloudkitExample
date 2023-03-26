//
//  CKService.swift
//  Notes_CloudPushNotification
//
//  Created by Apple on 11/03/23.
//

import Foundation
import CloudKit

class CKService {
    
    private init(){}
    static let shared = CKService()
    
    
    let privateDatabase  = CKContainer.default().privateCloudDatabase
    
    func save(record:CKRecord) {
        privateDatabase.save(record) { record, error in
            print(error ?? "no ck save error")
            print(record ?? "no ck save error")
        }
    }
    
    func query(recordType: String, completion:@escaping ([CKRecord]) -> Void) {
        
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        privateDatabase.perform(query, inZoneWith: nil) {(records,error) in
            print(error ?? "no ck error")
            guard let records = records else {return}
                completion(records)
        }
    }
    
    func subscribe() {
        
        let subcription = CKQuerySubscription(recordType: Note.recordType, predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        
        subcription.notificationInfo = notificationInfo
        privateDatabase.save(subcription) { sub, errror in
            print(errror ?? "no ck sub error")
            print(sub ?? "unable to subscribe")
        }
    }
 
    func subscribewithUI() { //...This is for Notifications
        
        let subcription = CKQuerySubscription(recordType: Note.recordType, predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
       
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "This is cool"
        notificationInfo.subtitle = "A Whole New iCloud"
        notificationInfo.alertBody = "I bet ya didnot know about the power of the cloud"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        
        subcription.notificationInfo = notificationInfo
        privateDatabase.save(subcription) { sub, errror in
            print(errror ?? "no ck sub error")
            print(sub ?? "unable to subscribe")
        }
    }
    
    
    
    func fetchRecords(with recordID: CKRecord.ID) {
        privateDatabase.fetch(withRecordID: recordID) { record, error in
            
            print(error ?? "no ck fecth error")
            guard let record = record else{return}
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("internalNotification.fetchRecord"), object: record)
            }
        }
    }
    
    func handleNotification(with userinfo:[AnyHashable: Any]) {
        
        let notification = CKNotification(fromRemoteNotificationDictionary: userinfo)
        switch notification?.notificationType {
        case .query:
            guard let queryNotification = notification as? CKQueryNotification,
                  let recordId  = queryNotification.recordID
            else {return}
            fetchRecords(with: recordId)
            
        default:
            return
        }
        
    }
    
    
    
}








































































