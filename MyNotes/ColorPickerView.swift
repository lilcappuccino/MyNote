//
//  ColorPickerView.swift
//  MyNotes
//
//  Created by dewill on 30/07/2019.
//  Copyright © 2019 dewill. All rights reserved.
//


import UIKit

protocol ColorPickerDelegate: NSObject {
    
    func didSelectColor(_ color: UIColor?)
}

@IBDesignable
class ColorPickerView: UIView {
    
    //    MARK: Public
    
    weak var delegate: ColorPickerDelegate?
    var initialColor: UIColor? {
        didSet {
            colorPreView.backgroundColor = initialColor
            colorLabel.text = initialColor?.toHexString()
            
        }
    }
    
    
    //    MARK: Private
    
    private struct Constants {
        static let brightness: CGFloat = 1.0
        static let elementSize: CGFloat = 1.0
        static let topViewHeight: CGFloat = 100
        static let offset: CGFloat = 16
        static let bottomOffset: CGFloat = offset * 3
    }
    
    private var topView: UIView!
    private var colorPreView: UIView!
    private var colorLabel: UILabel!
    private var brightnessSlider: UISlider!
    private var mainPalleteView: UIView!
    private var doneButton: UIButton!
    
    lazy var targetMark: UIView = {
        let a = UIView(frame: CGRect(origin: CGPoint(x:0, y:0), size: CGSize(width: 20, height: 20)))
        a.layer.borderColor = UIColor.black.cgColor
        a.layer.borderWidth = 0.5
        a.layer.cornerRadius = 10
        a.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return a
    }()
    
    //    MARK: Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not emplemented")
    }
    
    private func setup(frame: CGRect) {
        self.backgroundColor = .white
        setupTopView()
        setupPalleteView(frame: frame)
        setupButton()
    }
    
    private func setupTopView() {
        // topView contain all elements above colorful palette
        topView = UIView(frame: CGRect(x: Constants.offset,
                                       y: Constants.offset,
                                       width: frame.width - Constants.offset*2,
                                       height: Constants.topViewHeight))
        self.addSubview(topView)
        
        // colorContainerView contain color preview and color hex Label
        let colorContainerView = UIView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: Constants.topViewHeight - Constants.offset*2,
                                                      height: Constants.topViewHeight - Constants.offset))
        colorContainerView.layer.borderWidth = 1
        colorContainerView.layer.borderColor = UIColor.black.cgColor
        colorContainerView.layer.cornerRadius = 5
        
        colorPreView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: colorContainerView.frame.width,
                                            height: Constants.topViewHeight - Constants.offset*2))
        
        colorLabel = UILabel(frame: CGRect(x: colorPreView.frame.minX,
                                           y: colorPreView.frame.maxY,
                                           width: colorContainerView.frame.width,
                                           height: Constants.offset))
        colorLabel.font = UIFont.systemFont(ofSize: 14)
        colorLabel.textAlignment = .center
        
        colorContainerView.addSubview(colorPreView)
        colorContainerView.addSubview(colorLabel)
        colorContainerView.clipsToBounds = true
        
        // brightness elements
        let brightnessLabel = UILabel(frame: CGRect(
            x: colorContainerView.frame.maxX + Constants.offset,
            y: colorContainerView.frame.minY + Constants.offset,
            width: topView.frame.width - colorContainerView.frame.width - Constants.offset,
            height: Constants.offset*2))
        brightnessLabel.font = UIFont.systemFont(ofSize: 20)
        brightnessLabel.text = "Brightness:"
        
        brightnessSlider = UISlider(frame: brightnessLabel.frame)
        brightnessSlider.frame.origin.y += Constants.offset * 2
        brightnessSlider.minimumValue = -1
        brightnessSlider.maximumValue = 1
        brightnessSlider.addTarget(self, action: #selector(changingBrightness), for: .valueChanged)
        
        // adding all views
        topView.addSubview(colorContainerView)
        topView.addSubview(brightnessSlider)
        topView.addSubview(brightnessLabel)
        
    }
    
    private func setupPalleteView(frame: CGRect) {
        mainPalleteView = UIView(frame: CGRect(
            x: Constants.offset,
            y: topView.frame.height + Constants.offset,
            width: frame.width - Constants.offset * 2,
            height: frame.height - topView.frame.height - Constants.offset - Constants.bottomOffset))
        
        self.addSubview(mainPalleteView)
        mainPalleteView.layer.borderColor = UIColor.gray.cgColor
        mainPalleteView.layer.borderWidth = 1.0
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(recognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        mainPalleteView.addGestureRecognizer(touchGesture)
    }
    
    private func setupButton() {
        doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        
        let size = doneButton.intrinsicContentSize
        let origin = CGPoint(x: frame.width/2 - size.width/2,
                             y: mainPalleteView.frame.maxY + Constants.offset)
        doneButton.frame = CGRect(origin: origin, size: size)
        doneButton.addTarget(self, action: #selector(selectColor), for: .touchUpInside)
        
        self.addSubview(doneButton)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let mainPalleteRect = mainPalleteView.frame
        for y in stride(from: CGFloat(0), to: mainPalleteRect.height, by: Constants.elementSize) {
            
            var saturation = CGFloat(mainPalleteRect.height-y) / mainPalleteRect.height
            saturation = CGFloat(powf(Float(saturation), 1.0))
            
            for x in stride(from: Constants.offset, to: mainPalleteRect.width + Constants.offset, by: Constants.elementSize) {
                let hue = x / mainPalleteRect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: Constants.brightness, alpha: 1.0)
                context.setFillColor(color.cgColor)
                context.fill(CGRect(x: x,
                                    y: y + mainPalleteRect.origin.y,
                                    width: Constants.elementSize,
                                    height: Constants.elementSize))
                
            }
        }
    }
    
    private func getColorAtPoint(point: CGPoint) -> UIColor? {
        var roundedPoint = CGPoint(x: Constants.elementSize * CGFloat(Int(point.x / Constants.elementSize)),
                                   y: Constants.elementSize * CGFloat(Int(point.y / Constants.elementSize)))
        
        let hue = roundedPoint.x / mainPalleteView.frame.width
        guard mainPalleteView.frame.contains(point) else { return nil }
        
        let palleteFrame = mainPalleteView.frame
        roundedPoint.y -= palleteFrame.origin.y
        roundedPoint.x -= palleteFrame.origin.x
        var saturation = CGFloat(palleteFrame.height - roundedPoint.y) / palleteFrame.height
        saturation = CGFloat(powf(Float(saturation), 1.0))
        
        initialColor = UIColor(hue: hue, saturation: saturation, brightness: Constants.brightness, alpha: 1.0)
        return initialColor
    }
    
    @objc func changingBrightness() {
        colorPreView.backgroundColor = initialColor?.modified(additionalBrightness: CGFloat(brightnessSlider.value))
    }
    
    @objc private func touchedColor(recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: self)
        guard let color = getColorAtPoint(point: point) else { return }
        targetMark.frame.origin = CGPoint(x: recognizer.location(in: mainPalleteView).x - 10,
                                          y: recognizer.location(in: mainPalleteView).y - 10)
        mainPalleteView.addSubview(targetMark)
        initialColor = color.modified(additionalBrightness: CGFloat(brightnessSlider.value))
        colorPreView.backgroundColor = initialColor
    }
    
    @objc private func selectColor(_ sender: UIButton?) {
        initialColor = initialColor?.modified(additionalBrightness: CGFloat(brightnessSlider.value))
        self.delegate?.didSelectColor(initialColor)
        self.removeFromSuperview()
    }
}




private extension UIColor {
    
    // get Hex String for color
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    // get modified color with brightness
    func modified(withAdditionalHue hue: CGFloat = 0,
                  additionalSaturation: CGFloat = 0,
                  additionalBrightness: CGFloat = 0) -> UIColor {
        
        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0
        
        if self.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha){
            return UIColor(hue: currentHue + hue,
                           saturation: currentSaturation + additionalSaturation,
                           brightness: currentBrigthness + additionalBrightness,
                           alpha: currentAlpha)
        } else { return self }
    }
}


