//
//  ColorCircleUIView.swift
//  MyNotes
//
//  Created by dewill on 24/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import UIKit

@IBDesignable
class CircleUIView: UIView {
    
    @IBInspectable var isChecked = false
    
    @IBInspectable var mainColor: UIColor = UIColor.blue
        {
        didSet { print("mainColor was set here")
        }
    }
    @IBInspectable var ringColor: UIColor = UIColor.orange
        {
        didSet { print("bColor was set here") }
    }
    @IBInspectable var ringThickness: CGFloat = 4
        {
        didSet { print("ringThickness was set here") }
    }
    
    @IBInspectable var isGradient: Bool = false {
        didSet { setNeedsLayout(); setNeedsDisplay() }
    }
    
    @IBInspectable var isSelected: Bool = false
    {
        didSet {
            imageView?.isHidden = !isSelected
        }
    }
    
    var imageView : UIImageView?
    
    override func draw(_ rect: CGRect)
    {
        
        let dotPath = UIBezierPath(ovalIn:rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dotPath.cgPath
        shapeLayer.fillColor = mainColor.cgColor
        drawGradientOrColor(with: shapeLayer)
        addMarkView()
        imageView?.isHidden = !isSelected
        

      
//        if (isSelected) { drawRingFittingInsideView(rect: rect) }
    }
    
    // MARK -> select between coolor and gradient fill
    internal func drawGradientOrColor(with shapeLayer : CAShapeLayer){
        var view :CALayer = shapeLayer
        if isGradient {
            print("uddate layour")
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor.green.cgColor,
                               UIColor.red.cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            gradient.mask = shapeLayer
            gradient.frame = bounds
            view = gradient
            }
         layer.addSublayer(view)
    }
    
    private func addMarkView(){
        let imageName = "hand_ok"
        let image = UIImage(named: imageName)
        guard (image != nil ) else { return }
        imageView = UIImageView(image: image)
        imageView!.frame = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width * 0.5, height: bounds.height * 0.5))
        imageView!.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addSubview(imageView!)
        
    }
    
    
    internal func drawRingFittingInsideView(rect: CGRect)-> ()
    {
        let hw : CGFloat = ringThickness/2
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: hw, y: hw), size: rect.size ))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = ringColor.cgColor
        shapeLayer.lineWidth = ringThickness
        layer.addSublayer(shapeLayer)
    }
}

