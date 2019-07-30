//
//  NotesListViewContollerViewController.swift
//  MyNotes
//
//  Created by dewill on 29/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController {
    
    let segueIndeficator = "CreateNote"

    override func viewDidLoad() {
        super.viewDidLoad()
         print("viewDidLoad")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(performSegueForCreateNote))
    
        self.navigationController?.title = "Notes"
        self.navigationItem.title = "Notes"
        

        // Do any additional setup after loading the view.
    }

    
    @objc func performSegueForCreateNote(){
        print("performSegueForCreateNote")
        performSegue(withIdentifier: "CreateNote", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
