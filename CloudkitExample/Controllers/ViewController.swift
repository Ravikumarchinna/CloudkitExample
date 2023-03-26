//
//  ViewController.swift
//  CloudkitExample
//
//  Created by Apple on 12/03/23.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tblv_notes: UITableView!
    
    var notes = [Note]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // CKService.shared.subscribe() //...This is for Notificatons
        CKService.shared.subscribewithUI() //...This is for Notificatons

        UNService.shared.authorize() //...We can do it this one from the Appdelegate Didfinish Launching with Options
        self.getNotes()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFtech( _:)),
                                               name: Notification.Name("internalNotification.fetchRecord"),
                                               object: nil)
        
    }
    
    func getNotes() {
        NoteService.getNotes { (notes) in
            self.notes = notes
            print("Get the data -->%@",notes)
            DispatchQueue.main.async {
                self.tblv_notes.reloadData()
            }
        }
    }
    
    
    
    @IBAction func onComposeTapped(_ sender: Any) {
        
        AlertService.composeNote(in: self) { note in
            CKService.shared.save(record: note.noteRecord())
            self.insert(note: note)
        }
    }
    
    func insert(note: Note) {
        notes.insert(note, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tblv_notes.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func handleFtech(_ sender: Notification) {
        guard let record = sender.object as? CKRecord,
        let note = Note(record: record)
        else {return}
        insert(note: note)
    }
    
    
}





extension ViewController:UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(notes)
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        return cell
    }
    
}
