//
//  ViewController.swift
//  MyNotes
//
//  Created by dewill on 17/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import UIKit
import ChromaColorPicker

class OldCreateNoteViewController: UIViewController, UIGestureRecognizerDelegate, ChromaColorPickerDelegate {
    

    @IBOutlet weak var inputtingContentTextView: UITextView!
    @IBOutlet weak var colorChooserDialogView: UIVisualEffectView!
    @IBOutlet weak var colorPickerView: ChromaColorPicker!
    @IBOutlet weak var colorDialogView: UIView!
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var colorsStackView: UIStackView!
    @IBOutlet weak var destroyDateSwitcher: UISwitch!
    @IBOutlet var colorsChooserView: [CircleUIView]!
  
    @IBAction func onDatePickerSwitcherChange(_ sender: UISwitch) {
        destroyDatePicker.isHidden = !sender.isOn
        updateColorPickerAchor(isDataPickerOn: sender.isOn)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        destroyDatePicker.isHidden = true
//        prepareUITextView()
        updateColorPickerAchor(isDataPickerOn: destroyDateSwitcher.isOn)
        registerGuesureForColorsButton()
        colorsChooserView.first?.isGradient = true
        colorDialogView.layer.cornerRadius = 10
    }
    
    
    //MARK -> re-wirte this
    @objc func onColorChooserClick(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: colorsChooserView[0])
        guard let colorButtonIndex = colorsChooserView.firstIndex(where: {
            $0.frame.contains(touchPoint) }) else { return }
        colorsChooserView.forEach{ $0.isSelected = false }
        colorsChooserView[colorButtonIndex].isSelected = true
        if colorsChooserView[colorButtonIndex].isGradient {
           showColorPicker()
        }
    }
    
    private func showColorPicker() {
        colorChooserDialogView.isHidden = false
        colorPickerView.delegate = self
        
    }
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        colorChooserDialogView.isHidden = true
        colorsChooserView[0].mainColor = color
        colorsChooserView[0].setNeedsDisplay()
        
    }
    
    @IBAction func onColorDialogCancelClick(_ sender: Any) {
        colorChooserDialogView.isHidden = true
    }
    
    
    var constraint: NSLayoutConstraint? = nil
    private func updateColorPickerAchor(isDataPickerOn: Bool){
        constraint?.isActive = false
        let anchor = isDataPickerOn ? destroyDatePicker.bottomAnchor : destroyDateSwitcher.bottomAnchor
        constraint = colorsStackView.topAnchor.constraint(equalTo: anchor, constant: 20)
        constraint?.isActive = true
    }
    
    private func registerGuesureForColorsButton(){
        colorsChooserView.forEach { view in
        let tap = UITapGestureRecognizer(target: self, action: #selector(onColorChooserClick(sender:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        }
    }
    
//    private func prepareUITextView(){
//        inputtingContentTextView.delegate = self
//        textViewDidChange(inputtingContentTextView)
//        inputtingContentTextView.isScrollEnabled = false
    }
 

//}


/*extension CreateNoteViewController : UITextViewDelegate {
    
    // MARK : view height is auto counting
     func textViewDidChange(_ textView: UITextView) {
       let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { constraint in
            guard constraint.firstAttribute == .height else { return }
            constraint.constant = estimatedSize.height
        }
    }
}/
 */


    
    



