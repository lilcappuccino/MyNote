//
//  CreateNoteViewController.swift
//  MyNotes
//
//  Created by dewill on 29/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import UIKit

class CreateNoteViewController: UIViewController , ColorStackDelegate, ColorPickerDelegate {
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var colorStackView: ColorStackUIView!
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var destroyDateSwitcher: UISwitch!
    
    public var selectedColor = UIColor.white {
        didSet{
           updateNoteBackground()
        }
    }
    let colorPickerIdentificator = "ColorPicker"
    
    var note : Note?
    
    
    @IBAction func switchDestroyNoteDate(_ sender: UISwitch) {
        destroyDatePicker.isHidden = !sender.isOn
         updateColorPickerAchor(isDataPickerOn: sender.isOn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        navigationItem.title = "Edit Note"
        prepareContentTextView()
        colorStackView.delegate = self
        tabBarController?.tabBar.isHidden = true
        updateColorPickerAchor(isDataPickerOn: destroyDateSwitcher.isOn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(seveNote))
        inputingDataFromNote()
        coutingSize(for: contentTextView)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func seveNote(){
        FileNotebook.get.add(Note(uid: note?.uid, title: titleText.text ?? "", content: contentTextView.text, color: selectedColor, selfDestructionDate: nil, importance: Note.Importance.hight))
        FileNotebook.get.saveToFile()
        navigationController?.popViewController(animated: true)
    }
    
    
    private func inputingDataFromNote(){
        if let currentNote = note {
            titleText.text = currentNote.title
            contentTextView.text = currentNote.content
            contentTextView.textColor = UIColor.black
            selectedColor = currentNote.color
        }
        
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
    
    
    var constraint: NSLayoutConstraint? = nil
    private func updateColorPickerAchor(isDataPickerOn: Bool){
        constraint?.isActive = false
        let anchor = isDataPickerOn ? destroyDatePicker.bottomAnchor : destroyDateSwitcher.bottomAnchor
        constraint = colorStackView.topAnchor.constraint(equalTo: anchor, constant: 20)
        constraint?.isActive = true
    }
    
    private func coutingSize(for textView: UITextView){
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { constraint in
            guard constraint.firstAttribute == .height else { return }
            constraint.constant = estimatedSize.height
        }
    }
    
    
    let colorAlpha: CGFloat = 0.2
    private func updateNoteBackground (){
        titleText.backgroundColor = selectedColor.withAlphaComponent(colorAlpha)
        contentTextView.backgroundColor = selectedColor.withAlphaComponent(colorAlpha)
        
    }
    
    

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
    
    func didSelectColor(color: UIColor?) {
        if let currentColor = color { selectedColor = currentColor }
    }
    
    func didSelectColor(_ color: UIColor?) {
        fatalError()
    }
    
    
    func onGradientColorClick() {
         performSegue(withIdentifier: colorPickerIdentificator, sender: nil)
    }
}
