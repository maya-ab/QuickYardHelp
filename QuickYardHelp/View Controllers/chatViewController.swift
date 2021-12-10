//
//  chatViewController.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-07-28.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit

import Firebase
import FirebaseFirestore
import FirebaseAuth

class chatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    let currentUserRef = Auth.auth().currentUser?.uid ?? "nil"
    
    var messagesDocID = ""
    var messageDoc = ""
    
    var path = ""
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
                 
        tableView.dataSource = self
        super.viewDidLoad()
        tableView.register(UINib(nibName: "messageTableViewCell", bundle: nil), forCellReuseIdentifier: "ReuseableCell")
        
        tableView.register(UINib(nibName: "secondMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "ReuseableCellTwo")
        obtainPath()
        
       //loadMessages()

        
    }
    
    func obtainPath() {
        
        db.collection("users").document(currentUserRef).getDocument { (document, err) in
            
            if let document = document, document.exists {
                
                self.path = document.get("path") as! String
                self.loadMessages()
                
            }
        }
    }


    func loadMessages() {
        self.messages = []
        
        
        db.collection(self.path).order(by: "date").addSnapshotListener { (querySnapshot, err) in
            self.messages = []
    
            
            if let e = err {
                print("Issue getting data from firebase")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        
                        if let sender = doc.get("sender") as? String, let messageBody = doc.get("body") as? String {
                            
                            let newMessage = Message(sender: sender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                            
                        }
                    }
                }
            
            }
            
        }
        
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        
        if messageTextField.text == "" {
            return
        }

        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            
            //create new document within messages for every message
            db.collection(self.path).addDocument(data: [
                "sender": messageSender,
                "body": messageBody,
                "date": Date().timeIntervalSince1970])
            
            { (error) in
                if let e = error {
                    print("Issue saving data to firestore \(e)")
                } else {
                     //Message succesfully sent
                    DispatchQueue.main.async {
                        self.messageTextField.text = ""
                    }

                }
            }
            
        }
    
    }
    

}

extension chatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]

        //Message is from current user
        if message.sender == Auth.auth().currentUser?.email {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseableCell", for: indexPath) as! messageTableViewCell
                       cell.label.text = message.body
            return cell
    
        } else { //Other person
            
            let secondCell = tableView.dequeueReusableCell(withIdentifier: "ReuseableCellTwo", for: indexPath) as! secondMessageTableViewCell
            secondCell.label.text = message.body
            
             return secondCell
             
        
        }
        
    }
    
}

