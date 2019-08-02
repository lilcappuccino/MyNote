//
//  NotesListViewContollerViewController.swift
//  MyNotes
//
//  Created by dewill on 29/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var tableView: UITableView!
    
    let sugueIndeficatorOpen = "OpenNote"
    
    private var clickedItemIndex : IndexPath?
    
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(performSegueForCreateNote))
        navigationItem.title = "Notes"
        navigationController?.tabBarItem.image = UIImage(named: "paper_icon")
        tableView.delegate = self
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         tabBarController?.tabBar.isHidden = false
//        let fileNotebook = FileNotebook()
        FileNotebook.get.loadFromFile()
        notes = FileNotebook.get.notes.reversed()
        tableView.reloadData()
        
    }

    
    @objc func performSegueForCreateNote(){
        performSegue(withIdentifier: sugueIndeficatorOpen, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == sugueIndeficatorOpen {
            if let vc = segue.destination as? CreateNoteViewController , let index = clickedItemIndex?.row {
                vc.note = notes[index]
                clickedItemIndex = nil
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
        print(cell)
        let currentNote = notes[indexPath.item]
        cell.titleLable.text = currentNote.title
        cell.contentLable.text = currentNote.content
        cell.colorView.backgroundColor = currentNote.color
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       clickedItemIndex = indexPath
       performSegue(withIdentifier: sugueIndeficatorOpen, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            FileNotebook.get.replace(to: notes)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    

}


