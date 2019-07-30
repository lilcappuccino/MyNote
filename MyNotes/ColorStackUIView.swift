//
//  ColorStackUIView.swift
//  MyNotes
//
//  Created by dewill on 29/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import UIKit

public protocol ColorStackDelegate {
    func onGradientColorClick()
}


@IBDesignable
class ColorStackUIView: UIView , UIGestureRecognizerDelegate{

    @IBOutlet var colorList: [UIView]!
    
    var delegate: ColorStackDelegate? = nil
  
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(loadViewFromNib())
        colorList.forEach{ $0.layer.cornerRadius = 5; addBorderForWhiteView(to: $0)}
        addGradient()
        registerGuesureForColorsButton()

    }
    
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorStackUIView", bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    
    private func registerGuesureForColorsButton(){
            let tap = UITapGestureRecognizer(target: self, action: #selector(onColorChooserClick(sender:)))
            tap.delegate = self
            self.addGestureRecognizer(tap)
    }

    @objc func onColorChooserClick(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: colorList[0])
        let colorButtonIndex =  colorList.firstIndex(where: {$0.frame.contains(touchPoint)})
        if let index = colorButtonIndex  {
            colorList.forEach {
                $0.layer.borderWidth = 0
                addBorderForWhiteView(to: $0)
            }
            colorList[index].layer.borderColor = UIColor.black.cgColor
            colorList[index].layer.borderWidth = 2
            if colorList[index] == colorList?.last {
                delegate?.onGradientColorClick()
            }
        }
    }
    
    private func addBorderForWhiteView(to view : UIView){
        guard view.backgroundColor == UIColor.white else { return }
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
    }
    
    private func showColorPicker() {
        let colorPickerView = ColorPickerView(frame: self.safeAreaLayoutGuide.layoutFrame)
        
        addSubview(colorPickerView)
//        colorPickerView.delegate = self
//        colorPickerView.initialColor = selectedColor
//        isColorPickerViewDisplaing = true
    }
    
    private func addGradient(){
        if let lastView = colorList?.last{
        let gradient = CAGradientLayer()
        gradient.frame = lastView.bounds
        gradient.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        gradient.cornerRadius = 5
        lastView.layer.insertSublayer(gradient, at: 0)
        }
    }
}
