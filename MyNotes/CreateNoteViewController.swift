//
//  CreateNoteViewController.swift
//  MyNotes
//
//  Created by dewill on 29/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import UIKit

class CreateNoteViewController: UIViewController {
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Note"
        prepareContentTextView()
        
     
        // Do any additional setup after loading the view.
    }
    
    
    private func prepareContentTextView(){
        contentTextView.isScrollEnabled = false
        contentTextView.text = "Your note content will be here"
        contentTextView.textColor = UIColor.lightGray
        contentTextView.delegate = self
        contentTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.cornerRadius = 5
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

extension CreateNoteViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK : view height is auto counting
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { constraint in
            guard constraint.firstAttribute == .height else { return }
            constraint.constant = estimatedSize.height
        }
    }
    
}
