//
//  DVActionSheet.swift
//  DVActionSheetExample
//
//  Created by Đặng Vinh on 5/12/15.
//  Copyright (c) 2015 DVISoft. All rights reserved.
//

import UIKit

@objc protocol DVActionSheetDelegate {
    optional func dvActionSheetWillAppear(#dvActionSheet: DVActionSheet)
    optional func dvActionSheetDidAppear(#dvActionSheet: DVActionSheet)
    optional func dvActionSheetWillDisappear(#dvActionSheet: DVActionSheet)
    optional func dvActionSheetDidDisappear(#dvActionSheet: DVActionSheet)
    optional func dvActionSheet(#dvActionSheet: DVActionSheet, didClickButtonAtIndex: Int)
}

class DVActionSheetButton: UIButton {
    
    enum DVActionSheetButtonType {
        case Normal
        case Cancel
        case Destructive
    }
    
    var dvActionSheetButtonType: DVActionSheetButtonType?
    
    var dvTitle: String? {
        willSet(value) {self.setTitle(value, forState: UIControlState.Normal) }
    }
    var dvFont: UIFont? {
        willSet(value) { self.titleLabel?.font = value }
    }
    var dvTitleColor: UIColor? {
        willSet(value) { self.setTitleColor(value, forState: UIControlState.Normal) }
    }
    var dvBackgroundColor: UIColor? {
        willSet(value) { self.backgroundColor = value }
    }
    
    var dvCornerRadius: CGFloat? {
        willSet(value) { self.layer.cornerRadius = value! }
    }
    
    var index: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttributesForNormalButton(#title: String, titleColor: UIColor, backgroundColor: UIColor) {
        dvTitle = title
        dvTitleColor = titleColor
        dvBackgroundColor = backgroundColor
    }
    
    func setAttributesForCancelButton(#title: String) {
        dvTitle = title
        dvTitleColor = UIColor.whiteColor()
        dvBackgroundColor = UIColor(red: 0.404, green: 0.827, blue: 0.882, alpha: 1.0)
    }
    
    func setAttributesForDestructiveButton(#title: String) {
        dvTitle = title
        dvTitleColor = UIColor.whiteColor()
        dvBackgroundColor = UIColor(red: 0.780, green: 0.200, blue: 0.290, alpha: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dvFont = UIFont(name: "Helvetica", size: 16)
        dvCornerRadius = 5
    }
}

class DVActionSheet: UIViewController {
    
    enum DVActionSheetPresentStyle {
        case DropDownFromTop
        case DropUpFromBottom
        case SlideFromLeft
        case SlideFromRight
    }
    
    enum DVActionSheetState {
        case Show
        case Hide
    }

    weak var delegate: DVActionSheetDelegate?
    var presentStyle = DVActionSheetPresentStyle.DropUpFromBottom
    var actionSheetState = DVActionSheetState.Hide
    var buttonArray = [DVActionSheetButton]()
    
    weak var target: UIViewController?
    weak var shadowView: UIView?
    
    var deviceWidth = UIScreen.mainScreen().bounds.width
    var deviceHeight = UIScreen.mainScreen().bounds.height
    let buttonWidth: CGFloat = UIScreen.mainScreen().bounds.width - 10
    let buttonHeight: CGFloat = 55
    
    let buttonFont = UIFont(name: "Helvetica", size: 16)
    let buttonTitleColor = UIColor.whiteColor()
    let buttonBackgroundColor = UIColor(red: 0.404, green: 0.827, blue: 0.882, alpha: 1.0)
    let buttonHightLightBackgroundColor = UIColor(red: 0.333, green: 0.690, blue: 0.780, alpha: 1.9)
    let buttonCornerRadius: CGFloat = 0
    let distance: CGFloat = 5
    
    var existDestructiveButton = true
    
    // MARK: - Init Methods
    
    init(title: String, delegate: DVActionSheetDelegate?, cancelButtonTitle: String, destructiveButtonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        addActionSheetWithTitle(title: title, delegate: delegate, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: destructiveButtonTitle)
    }
    
    init(title: String, delegate: DVActionSheetDelegate?, cancelButtonTitle: String, destructiveButtonTitle: String, otherButtonTitles: [String]?) {
        super.init(nibName: nil, bundle: nil)
        addActionSheetWithTitle(title: title, delegate: delegate, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: destructiveButtonTitle, otherButtonTitles: otherButtonTitles)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View States Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        if self.actionSheetState == .Show {
//            if self.presentStyle == .SlideFromLeft || self.presentStyle == .SlideFromRight {
//                deviceWidth = UIScreen.mainScreen().bounds.size.height
//                deviceHeight = UIScreen.mainScreen().bounds.size.width
//                println("\(deviceWidth) + \(deviceHeight)")
//                //view.removeConstraints(view.constraints())
//                setNewPositionForButtonsWhenRotateDevice()
//            }
//        }
//        
//    }
    
    // MARK: - Setup View Methods
    
    private func setupView() {
        view.frame = UIScreen.mainScreen().bounds
        view.backgroundColor = UIColor.clearColor()
        view.setTranslatesAutoresizingMaskIntoConstraints(true)
        view.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    // MARK: - Add Buttons Methods
    
    private func addActionSheetWithTitle(#title: String, delegate: DVActionSheetDelegate?, cancelButtonTitle: String, destructiveButtonTitle: String) {
        addActionSheetWithTitle(title: title, delegate: delegate, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: destructiveButtonTitle, otherButtonTitles: nil)
    }
    
    private func addActionSheetWithTitle(#title: String, delegate: DVActionSheetDelegate?, cancelButtonTitle: String, destructiveButtonTitle: String, otherButtonTitles: [String]?) {
        if !destructiveButtonTitle.isEmpty { addDestructiveButtonWithTitle(title: destructiveButtonTitle) }
        else { existDestructiveButton = false }
        
        if delegate != nil { self.delegate = delegate }
        if otherButtonTitles != nil {
            for title in otherButtonTitles! {
                addNormalButtonWithTitle(title: title, titleColor: buttonTitleColor, backgroundColor: buttonBackgroundColor)
            }
        }
        if !cancelButtonTitle.isEmpty { addCancelButtonWithTitle(title: cancelButtonTitle) }
        else { addCancelButtonWithTitle(title: "Cancel") }
    }
    
    private func addNormalButtonWithTitle(#title: String, titleColor: UIColor, backgroundColor: UIColor) {
        var button = DVActionSheetButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        button.center = CGPointMake(deviceWidth/2, deviceHeight + buttonHeight/2)
        button.dvActionSheetButtonType = .Normal
        button.setAttributesForNormalButton(title: title, titleColor: buttonTitleColor, backgroundColor: buttonBackgroundColor)
        button.index = existDestructiveButton ? buttonArray.count : buttonArray.count + 1
        button.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        buttonArray.append(button)
    }
    
    private func addCancelButtonWithTitle(#title: String) {
        var button = DVActionSheetButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        button.center = CGPointMake(deviceWidth/2, deviceHeight + buttonHeight/2)
        button.dvActionSheetButtonType = .Cancel
        button.setAttributesForCancelButton(title: title)
        button.index = existDestructiveButton ? buttonArray.count : buttonArray.count + 1
        button.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        buttonArray.append(button)
    }
    
    private func addDestructiveButtonWithTitle(#title: String) {
        var button = DVActionSheetButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        button.center = CGPointMake(deviceWidth/2, deviceHeight + buttonHeight/2)
        button.dvActionSheetButtonType = .Destructive
        button.setAttributesForDestructiveButton(title: title)
        button.index = buttonArray.count
        button.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        buttonArray.append(button)
    }
    
    // MARK: - Animation Methods
    
    func show(#target: UIViewController, style: DVActionSheetPresentStyle?) {
        if actionSheetState == .Show { return }
        delegate?.dvActionSheetWillAppear!(dvActionSheet: self)
        target.addChildViewController(self)
        target.view.addSubview(self.view)
        didMoveToParentViewController(target)
        //addVibrancyEffectToView(view)
        
        var vView = UIView()
        target.view.addSubview(vView)
        
        vView.setTranslatesAutoresizingMaskIntoConstraints(false)
        target.view.addConstraint(NSLayoutConstraint(item: vView, attribute: .Leading, relatedBy: .Equal, toItem: target.view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        target.view.addConstraint(NSLayoutConstraint(item: vView, attribute: .Trailing, relatedBy: .Equal, toItem: target.view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        target.view.addConstraint(NSLayoutConstraint(item: vView, attribute: .Top, relatedBy: .Equal, toItem: target.view, attribute: .Top, multiplier: 1.0, constant: 0.0))
        target.view.addConstraint(NSLayoutConstraint(item: vView, attribute: .Bottom, relatedBy: .Equal, toItem: target.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        vView.backgroundColor = UIColor.blackColor()
        //addVibrancyEffectToView(vView)
        self.shadowView = vView
        target.view.bringSubviewToFront(view)
        self.target = target
        presentStyle = style!
        showAllButtons()
    }
    
    private func hide() {
        delegate?.dvActionSheetWillDisappear!(dvActionSheet: self)
        if actionSheetState == .Hide { return }
        hideAllButtons()
    }
    
    private func showAllButtons() {
        var count: CGFloat = 0
        view.alpha = 0
        UIView.animateWithDuration(0.2, animations: { self.view.alpha = 1 })
        if presentStyle == .DropUpFromBottom { buttonArray = buttonArray.reverse() }
        
        var slideStartPoint: CGFloat = 0
        if presentStyle == .SlideFromLeft || presentStyle == .SlideFromRight {
            slideStartPoint = (deviceHeight - (CGFloat(buttonArray.count) * buttonHeight + CGFloat(buttonArray.count-1) * distance)) / 2
        }
        
        for button in buttonArray {
            switch(presentStyle) {
            case .DropDownFromTop:
                
                button.center = CGPoint(x: button.center.x, y: -buttonHeight/2)
                animateButtonToNewPosition(button, pos: CGPoint(x: button.center.x, y: self.distance*(count+1) + self.buttonHeight/2 + self.buttonHeight*count), show: true)

            case .DropUpFromBottom:
                button.center = CGPoint(x: button.center.x, y: deviceHeight + buttonHeight/2)
                animateButtonToNewPosition(button, pos: CGPoint(x: button.center.x, y: deviceHeight - self.distance*(count+1) - self.buttonHeight/2 - self.buttonHeight*count), show: true)
                
            case .SlideFromLeft:
                button.center = CGPoint(x: -buttonWidth/2, y: slideStartPoint + buttonHeight/2 + buttonHeight*count + distance*count)
                animateButtonToNewPosition(button, pos: CGPoint(x: distance + buttonWidth/2, y: button.center.y), show: true)
                
            case .SlideFromRight:
                button.center = CGPoint(x: deviceWidth + buttonWidth/2, y: slideStartPoint + buttonHeight/2 + buttonHeight*count + distance*count)
                animateButtonToNewPosition(button, pos: CGPoint(x: deviceWidth - distance - buttonWidth/2, y: button.center.y), show: true)
            default:
                break
            }
            self.view.bringSubviewToFront(button)
            count++
        }
        actionSheetState = .Show
        delegate?.dvActionSheetDidAppear!(dvActionSheet: self)
    }
    
    private func hideAllButtons(completion: ((Bool) -> Void)! = nil) {
        for button in buttonArray {
            switch(presentStyle) {
            case .DropDownFromTop:
                animateButtonToNewPosition(button, pos: CGPoint(x: button.center.x, y: -buttonHeight/2), show: false)
            case .DropUpFromBottom:
                animateButtonToNewPosition(button, pos: CGPoint(x: button.center.x, y: deviceHeight + buttonHeight/2), show: false)
            case .SlideFromLeft:
                animateButtonToNewPosition(button, pos: CGPoint(x: -buttonWidth/2, y: button.center.y), show: false)
            case .SlideFromRight:
                animateButtonToNewPosition(button, pos: CGPoint(x: deviceWidth + buttonWidth/2, y: button.center.y), show: false)
            default:
                break
            }
        }
        
        UIView.animateWithDuration(0.3, animations: {
                self.view.alpha = 0
            }, completion: { finished in
                self.actionSheetState = .Hide
                self.buttonArray.removeAll(keepCapacity: false)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                self.didMoveToParentViewController(nil)
                self.delegate?.dvActionSheetDidDisappear!(dvActionSheet: self)
        })
    }
    
    private func animateButtonToNewPosition(button: DVActionSheetButton, pos: CGPoint, show: Bool) {
        if show { shadowView?.alpha = 0 }
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            button.center = pos
            if show { self.shadowView?.alpha = 0.6 }
            else { self.shadowView?.alpha = 0 }
            }, completion: { finished in
                if !show { button.removeFromSuperview() }
                else { self.addConstraintForButton(button: button, animationType: self.presentStyle) }
        })
    }
    
    // MARK: - Auto Layout Methods
    
    func setNewPositionForButtonsWhenRotateDevice() {
        var count: CGFloat = 0
        var slideStartPoint: CGFloat = 0
        slideStartPoint = (deviceHeight - (CGFloat(buttonArray.count) * buttonHeight + CGFloat(buttonArray.count-1) * distance)) / 2
        for button in buttonArray {
            switch(presentStyle) {
            case .SlideFromLeft:
                button.center = CGPoint(x: deviceWidth/2, y: slideStartPoint + buttonHeight/2 + buttonHeight*count + distance*count)
                break
            case .SlideFromRight:
                button.center = CGPoint(x: deviceWidth/2, y: slideStartPoint + buttonHeight/2 + buttonHeight*count + distance*count)
                break
            default:
                break
            }
            addConstraintForButton(button: button, animationType: self.presentStyle)
            count++
        }
    }
    
    func addConstraintForButton(#button: DVActionSheetButton, animationType: DVActionSheetPresentStyle ) {
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left , relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: self.distance))
        self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Right , relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -self.distance))
        self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height , relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: self.buttonHeight))
        
        if animationType == .DropDownFromTop {
            var dis = CGRectGetMinY(button.frame)
            self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top , relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: dis))
        } else if animationType == .DropUpFromBottom {
            var dis = CGRectGetMaxY(button.frame) - self.deviceHeight
            self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom , relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: dis))
        } else {
            var dis = CGRectGetMinY(button.frame)
//            self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top , relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: dis))
            self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            var startPoint = -(deviceHeight/2 - CGRectGetMidY(button.frame))
            self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterYWithinMargins, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterYWithinMargins, multiplier: 1.0, constant:startPoint))
        }
    }
    
    // MARK: - Supporting Methods
    
    private func addVibrancyEffectToView(currentView: UIView) {
        let blurE: UIBlurEffect = UIBlurEffect(style: .Dark)
        let blurV: UIVisualEffectView = UIVisualEffectView(effect: blurE)
        blurV.frame = currentView.frame
        blurV.setTranslatesAutoresizingMaskIntoConstraints(false)
        currentView.addSubview(blurV)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    // MARK: - Button Methods
    
    func buttonAction(button: DVActionSheetButton) {
        if button.index == buttonArray.count-1 { hide() }
        delegate?.dvActionSheet!(dvActionSheet: self, didClickButtonAtIndex: button.index!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
