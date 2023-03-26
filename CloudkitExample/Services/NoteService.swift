//
//  NoteService.swift
//  CloudkitExample
//
//  Created by Apple on 12/03/23.
//

import Foundation



class NoteService {
    
    private init() {}
    
    static func getNotes(completion:@escaping ([Note])-> Void) {
        
        CKService.shared.query(recordType: Note.recordType) { (records) in
            var notes = [Note]()
            for record in records {
                let note  = Note(record: record)
                guard let note = note else { continue}
                notes.append(note)
            }
            completion(notes)
        }
        
    }
}









































































































