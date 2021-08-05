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
        
       // print("getting doc path")
     //   getDocPath()
       // print("going to load messages")
       // getDocPath()
      //  print(path)
       loadMessages()

        
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
                            }
                            
                        }
                    }
                }
            
            }
            
        }
        
    }
    
    @IBAction func sendPressed(_ sender: Any) {

        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            
            
            //create new document within messages for every message
            db.collection(self.path).addDocument(data: [
                "sender": messageSender,
                "body": messageBody,
                "date": Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("Issue saving data to firestore \(e)")
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
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseableCell", for: indexPath) as! messageTableViewCell
        
        cell.label.text = message.body
        
        //Message is from current user
        if message.sender == Auth.auth().currentUser?.email {
    
        } else { //Other person
            cell.messageBubble.backgroundColor = UIColor(named: "messageColour")

            cell.messageBubbleFrontConstraint.constant = 0.00
            print("added front constraint")
            cell.messageBubble.updateConstraints()
            
           // print("update")
            cell.stackBackConstraint.constant = 100.00
          //   print("back constraint added")
           cell.updateConstraints()
         //   print("update")
        
        }
        
        return cell
    }
    
}

