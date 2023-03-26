//
//  AlertService.swift
//  Notes_CloudPushNotification
//
//  Created by Apple on 11/03/23.
//

import Foundation
import UIKit

class AlertService {
    
    private init() {}
    
    
    static func composeNote(in vc: UIViewController, completion:@escaping (Note)-> Void) {
        
        let alert = UIAlertController(title: "New Note", message: "What's on your mind?", preferredStyle: .alert)
        alert.addTextField{(titleTF) in
            titleTF.placeholder = "Title"
        }
        let post = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let title = alert.textFields?.first?.text else{return}
            
            let note = Note(title: title)
            completion(note)
        }
        alert.addAction(post)
        vc.present(alert, animated: true)
        
    }
    
}






























































