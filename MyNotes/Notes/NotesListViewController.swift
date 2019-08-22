//
//  NotesListViewContollerViewController.swift
//  MyNotes
//
//  Created by dewill on 29/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var tableView: UITableView!
    
    let sugueIndeficatorOpen = "OpenNote"
    let TAG = "NotesListViewController"
    
    private var clickedItemIndex : IndexPath?
    
    var backgroundContext: NSManagedObjectContext!
    {
        didSet{
            CustomLog.waring(tag: TAG, message: "is backgroundContext = nil? \(backgroundContext == nil)")
             loadContent()
        }
    }
    
    let backendQueue = OperationQueue()
    let dbQueue = OperationQueue()
    let commonQueue = OperationQueue()
    
    var loadFromDataStore = false
    var needShowErrorDialog = false
    
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(performSegueForCreateNote))
        navigationItem.title = "Notes"
        navigationController?.tabBarItem.image = UIImage(named: "paper_icon")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CustomLog.info(tag: TAG, message: "viewWillAppear")
         tabBarController?.tabBar.isHidden = false
         showLoadingState()
        if !needShowErrorDialog, let _ = backgroundContext {
         loadContent()
          }
        }
    
    private func showLoadingState(){
        let uiBusy = UIActivityIndicatorView(style: .gray)
        uiBusy.hidesWhenStopped = true
        uiBusy.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
    }
    
    private func loadContent(){
        if !loadFromDataStore {
        guard NoteDefaults.token != nil else { requestToken();  return}
        }
    
        CustomLog.info(tag: TAG, message: "LoadContent")
        let loadOperation = LoadNoteOperation(notebook: FileNotebook.shared, backendQueue: backendQueue, dbQueue: dbQueue, backgroundContext: backgroundContext)
        commonQueue.addOperation(loadOperation)
        let uiBlock = BlockOperation{
            if let loadedNotes = loadOperation.notes {
                self.notes = loadedNotes.reversed()
                CustomLog.info(tag: self.TAG, message: "notes count \(self.notes.count)")
                self.tableView.reloadData()
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.performSegueForCreateNote))
            }
        }
        uiBlock.addDependency(loadOperation)
        OperationQueue.main.addOperation(uiBlock)
        
    }
    
    private func requestToken(){
        let requestTokenViewController = AuthViewController()
        requestTokenViewController.delegate = self
        present(requestTokenViewController, animated: false, completion: nil)
    }
    
    @objc func performSegueForCreateNote(){
        performSegue(withIdentifier: sugueIndeficatorOpen, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == sugueIndeficatorOpen {
            if let vc = segue.destination as? CreateNoteViewController {
                if let index = clickedItemIndex?.row {
                    vc.note = notes[index]
                }
                vc.backgroundContext = backgroundContext
                clickedItemIndex = nil
    
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
        let currentNote = notes[indexPath.item]
        cell.titleLable.text = currentNote.title
        cell.contentLable.text = currentNote.description
        cell.colorView.backgroundColor = currentNote.color
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       clickedItemIndex = indexPath
       performSegue(withIdentifier: sugueIndeficatorOpen, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
    
            let removeOperation = RemoveNoteOperation(noteUid: notes[indexPath.row].uid, notebook: FileNotebook.shared, backgroundContext: backgroundContext, backendQueue: backendQueue, dbQueue: dbQueue)
            commonQueue.addOperation(removeOperation)
            let uiBlock = BlockOperation {
                self.notes.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .bottom)
                tableView.endUpdates()
            }
          OperationQueue.main.addOperation(uiBlock)
            
        }
    }
    private func showErrorMessage(){
        needShowErrorDialog = true
        let alert = UIAlertController(title: "Oops", message: "Something was wrong. Try again", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: retryLoading))
        alert.addAction(UIAlertAction(title: "Load from local store", style: .default, handler: loadFromLocalDataStore ))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func retryLoading(action: UIAlertAction){
        loadFromDataStore = false
        needShowErrorDialog = false
        loadContent()
    }
    
    private func loadFromLocalDataStore(action: UIAlertAction){
        loadFromDataStore = false
        needShowErrorDialog = false
        loadContent()
    }
    
  }

extension NotesListViewController : AuthViewControllerDelegate {
    func handleTokenChanged(code: String) {
        getTokent(with: code)
    }
    
   private func getTokent(with code: String) {
        var components = URLComponents(string: "https://github.com/login/oauth/access_token")
        components?.queryItems = [URLQueryItem(name: "client_id", value: clientId),
                                  URLQueryItem(name: "client_secret", value: clientSecret),
                                  URLQueryItem(name: "code", value: code)]
    
        guard let url = components?.url else { return  showErrorMessage()}
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
    
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data  else { self.showErrorMessage(); return}
            do {
                if let content = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                    if let accessToken = content["access_token"] as? String {
                    NoteDefaults.token = accessToken
                        self.loadContent()
                    }
                }
            } catch let error {
                 self.showErrorMessage()
                CustomLog.error(tag: self.TAG, message: error.localizedDescription)
            }
    
        }
        task.resume()
    }
    
    
}



