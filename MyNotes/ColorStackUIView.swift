//
//  ColorStackUIView.swift
//  MyNotes
//
//  Created by dewill on 29/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import UIKit

class ColorStackUIView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("ColorStackUIView init")
        addSubview(loadViewFromNib())
    }
    
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorStackUIView", bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }

}
