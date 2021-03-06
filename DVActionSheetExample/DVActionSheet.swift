//
//  DVActionSheet.swift
//  DVActionSheetExample
//
//  Created by Đặng Vinh on 5/12/15.
//  Copyright (c) 2015 DVISoft. All rights reserved.
//

import UIKit

@objc protocol DVActionSheetDelegate {
    optional func dvActionSheetWillAppear(dvActionSheet dvActionSheet: DVActionSheet)
    optional func dvActionSheetDidAppear(dvActionSheet dvActionSheet: DVActionSheet)
    optional func dvActionSheetWillDisappear(dvActionSheet dvActionSheet: DVActionSheet)
    optional func dvActionSheetDidDisappear(dvActionSheet dvActionSheet: DVActionSheet)
    optional func dvActionSheet(dvActionSheet dvActionSheet: DVActionSheet, didClickButtonAtIndex: Int)
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
        dvFont = UIFont(name: "Helvetica", size: 24)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttributesForButton(title title: String, titleColor: UIColor, backgroundColor: UIColor, font: UIFont) {
        dvTitle = title
        dvTitleColor = titleColor
        dvBackgroundColor = backgroundColor
        dvFont = font
        dvCornerRadius = 3
    }
    
//    func setAttributesForCancelButton(title title: String) {
//        dvTitle = title
//        dvTitleColor = UIColor.blackColor()
////        dvBackgroundColor = UIColor(red: 0.404, green: 0.827, blue: 0.882, alpha: 1.0)
//        dvBackgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 1.0)
//    }
//    
//    func setAttributesForDestructiveButton(title title: String) {
//        dvTitle = title
//        dvTitleColor = UIColor.whiteColor()
////        dvBackgroundColor = UIColor(red: 0.780, green: 0.200, blue: 0.290, alpha: 1.0)
//        dvBackgroundColor = UIColor(red: 0.784, green: 0.216, blue: 0.349, alpha: 1.0)
//        dvFont = UIFont(name: "Helvetica-Bold", size: 16)
//    }
    
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
    weak var titleTextView: UITextView?
    
    var deviceWidth = UIScreen.mainScreen().bounds.width
    var deviceHeight = UIScreen.mainScreen().bounds.height
    let buttonWidth: CGFloat = UIScreen.mainScreen().bounds.width - 10
    let buttonHeight: CGFloat = 50
    
    let titleTextViewWidth: CGFloat = UIScreen.mainScreen().bounds.width - 10
    var titleTextViewHeight: CGFloat?
    
    let normalButtonFont = UIFont(name: "Helvetica", size: 16)
    let normalButtonTitleColor = UIColor.blackColor()
    let normalButtonBackgroundColor = UIColor(red: 0.920, green: 0.920, blue: 0.920, alpha: 1.0)
    let normalButtonHightLightBackgroundColor = UIColor(red: 0.333, green: 0.690, blue: 0.780, alpha: 1.9)
    
    let destructiveButtonFont = UIFont(name: "Helvetica-Bold", size: 16)
    let destructiveButtonTitleColor = UIColor.whiteColor()
    let destructiveButtonBackgroundColor = UIColor(red: 0.784, green: 0.216, blue: 0.349, alpha: 1.0)
    let destructiveButtonHightLightBackgroundColor = UIColor(red: 0.333, green: 0.690, blue: 0.780, alpha: 1.9)
    
    let cancelButtonFont = UIFont(name: "Helvetica", size: 16)
    let cancelButtonTitleColor = UIColor.blackColor()
    let cancelButtonBackgroundColor = UIColor(red: 0.920, green: 0.920, blue: 0.920, alpha: 1.0)
    let cancelButtonHightLightBackgroundColor = UIColor(red: 0.333, green: 0.690, blue: 0.780, alpha: 1.9)
    
    
    let buttonCornerRadius: CGFloat = 0
    let distance: CGFloat = 5
    let shadowViewValue: CGFloat = 0.7
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
    
    // MARK: - Setup View Methods
    
    private func setupView() {
        view.frame = UIScreen.mainScreen().bounds
        view.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Add Buttons Methods
    
    private func addActionSheetWithTitle(title title: String, delegate: DVActionSheetDelegate?, cancelButtonTitle: String, destructiveButtonTitle: String) {
        addActionSheetWithTitle(title: title, delegate: delegate, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: destructiveButtonTitle, otherButtonTitles: nil)
    }
    
    private func addActionSheetWithTitle(title title: String, delegate: DVActionSheetDelegate?, cancelButtonTitle: String, destructiveButtonTitle: String, otherButtonTitles: [String]?) {
        if !title.isEmpty { self.addTitleTextView(title: title) }
        if !destructiveButtonTitle.isEmpty { addDestructiveButtonWithTitle(title: destructiveButtonTitle, titleColor: destructiveButtonTitleColor, backgroundColor: destructiveButtonBackgroundColor, font: destructiveButtonFont!) }
        else { existDestructiveButton = false }
        
        if delegate != nil { self.delegate = delegate }
        if otherButtonTitles != nil {
            for title in otherButtonTitles! {
                addNormalButtonWithTitle(title: title, titleColor: normalButtonTitleColor, backgroundColor: normalButtonBackgroundColor, font: normalButtonFont!)
            }
        }
        if !cancelButtonTitle.isEmpty { addCancelButtonWithTitle(title: cancelButtonTitle, titleColor: cancelButtonTitleColor, backgroundColor: cancelButtonBackgroundColor, font: cancelButtonFont!) }
        else { addCancelButtonWithTitle(title: "Cancel", titleColor: cancelButtonTitleColor, backgroundColor: cancelButtonBackgroundColor, font: cancelButtonFont!) }
    }
    
    private func addTitleTextView(title title: String) {
        let newTextView = UITextView(frame: CGRect(x: (deviceWidth-titleTextViewWidth)/2, y: deviceHeight, width: titleTextViewWidth, height: 40))
        newTextView.text = title
        newTextView.textAlignment = NSTextAlignment.Center
        newTextView.font = UIFont(name: "Helvetica", size: 17)
        newTextView.textColor = UIColor.whiteColor()
        newTextView.backgroundColor = UIColor.clearColor()
        newTextView.layer.shadowOpacity = 0.8
        newTextView.scrollEnabled = false
        newTextView.editable = false
        
        let fixedWidth = titleTextViewWidth
        let newSize = newTextView.sizeThatFits(CGSize(width: fixedWidth, height: 0))
        titleTextViewHeight = newSize.height
        newTextView.frame.size.height = titleTextViewHeight!
        self.view.addSubview(newTextView)
        self.titleTextView = newTextView
    }
    
    private func addNormalButtonWithTitle(title title: String, titleColor: UIColor, backgroundColor: UIColor, font: UIFont) {
        let button = DVActionSheetButton(frame: CGRect(x: (deviceWidth-buttonWidth)/2, y: deviceHeight, width: buttonWidth, height: buttonHeight))
        button.dvActionSheetButtonType = .Normal
        button.setAttributesForButton(title: title, titleColor: titleColor, backgroundColor: backgroundColor, font: font)
        button.index = existDestructiveButton ? buttonArray.count : buttonArray.count + 1
        button.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        buttonArray.append(button)
    }
    
    private func addCancelButtonWithTitle(title title: String, titleColor: UIColor, backgroundColor: UIColor, font: UIFont) {
        let button = DVActionSheetButton(frame: CGRect(x: (deviceWidth-buttonWidth)/2, y: deviceHeight, width: buttonWidth, height: buttonHeight))
        button.dvActionSheetButtonType = .Cancel
        button.setAttributesForButton(title: title, titleColor: titleColor, backgroundColor: backgroundColor, font: font)
        button.index = existDestructiveButton ? buttonArray.count : buttonArray.count + 1
        button.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        buttonArray.append(button)
    }
    
    private func addDestructiveButtonWithTitle(title title: String, titleColor: UIColor, backgroundColor: UIColor, font: UIFont) {
        let button = DVActionSheetButton(frame: CGRect(x: (deviceWidth-buttonWidth)/2, y: deviceHeight, width: buttonWidth, height: buttonHeight))
        button.dvActionSheetButtonType = .Destructive
        button.setAttributesForButton(title: title, titleColor: titleColor, backgroundColor: backgroundColor, font: font)
        button.index = buttonArray.count
        button.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        buttonArray.append(button)
    }
    
    // MARK: - Animation Methods
    
    func showInView(target: UIViewController, style: DVActionSheetPresentStyle?) {
        if actionSheetState == .Show { return }
        delegate?.dvActionSheetWillAppear?(dvActionSheet: self)
        
        if let myTarget: UIViewController = target {
        
            myTarget.addChildViewController(self)
            myTarget.view.addSubview(self.view)
            didMoveToParentViewController(myTarget)
        
            let vView = UIView()
            myTarget.view.addSubview(vView)
        
            vView.translatesAutoresizingMaskIntoConstraints = false
            myTarget.view.addConstraint(NSLayoutConstraint(item: vView, attribute: .Leading, relatedBy: .Equal, toItem: myTarget.view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
            myTarget.view.addConstraint(NSLayoutConstraint(item: vView, attribute: .Trailing, relatedBy: .Equal, toItem: myTarget.view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
            myTarget.view.addConstraint(NSLayoutConstraint(item: vView, attribute: .Top, relatedBy: .Equal, toItem: myTarget.view, attribute: .Top, multiplier: 1.0, constant: 0.0))
            myTarget.view.addConstraint(NSLayoutConstraint(item: vView, attribute: .Bottom, relatedBy: .Equal, toItem: myTarget.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        
            vView.backgroundColor = UIColor.blackColor()
            myTarget.view.bringSubviewToFront(view)
        
            self.shadowView = vView
            self.target = myTarget
            presentStyle = style!
            showAllComponents()
        }
        
        
    }
    
    private func hideAllComponents() {
        if actionSheetState == .Hide { return }
        delegate?.dvActionSheetWillDisappear?(dvActionSheet: self)
        UIView.animateWithDuration(0.3, animations: {
            self.shadowView?.alpha = 0
            self.view.alpha = 0
            if self.target?.navigationController != nil {
                self.target?.navigationController?.navigationBar.hidden = false
                self.target?.navigationController?.navigationBar.alpha = 1
            }
            }, completion: { flag in
            self.shadowView?.removeFromSuperview()
            self.shadowView = nil
            self.actionSheetState = .Hide
                
            for button in self.buttonArray {
                button.removeFromSuperview()
            }
            self.titleTextView?.removeFromSuperview()
            self.titleTextView = nil
            self.buttonArray.removeAll(keepCapacity: false)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            self.didMoveToParentViewController(nil)
            self.delegate?.dvActionSheetDidDisappear?(dvActionSheet: self)

        })
        //hideTitleTextViewAndAllButtons()
    }
    
    private func showAllComponents() {
        shadowView?.alpha = 0
        UIView.animateWithDuration(0.3, animations: {
            self.shadowView?.alpha = self.shadowViewValue
            if self.target?.navigationController != nil {
                self.target?.navigationController?.navigationBar.alpha = 0
            }
            }, completion: { flag in
            if self.target?.navigationController != nil {
                self.target?.navigationController?.navigationBar.hidden = true
            }
        })
        
        if titleTextView != nil { showTitleTextView() }
        showAllButtons()
    }
    
    private func showTitleTextView() {
        switch(presentStyle) {
        case .DropDownFromTop:
            titleTextView?.center = CGPoint(x: titleTextView!.center.x, y: -titleTextViewHeight!/2)
            let cenY = deviceHeight - (deviceHeight - (CGFloat(buttonArray.count) * buttonHeight + CGFloat(buttonArray.count+1) * distance)) + titleTextViewHeight!/2
            animateTitleTextViewToNewPosition(titleTextView!, pos: CGPoint(x: titleTextView!.center.x, y: cenY), show: true)
            break
        case .DropUpFromBottom:
            let cenY = (deviceHeight - (CGFloat(buttonArray.count) * buttonHeight + CGFloat(buttonArray.count+1) * distance)) - titleTextViewHeight!/2
            animateTitleTextViewToNewPosition(titleTextView!, pos: CGPoint(x: titleTextView!.center.x, y: cenY), show: true)
            break
        case .SlideFromLeft:
            let cenX = -titleTextViewWidth/2
            let cenY = ((deviceHeight - (CGFloat(buttonArray.count) * buttonHeight + CGFloat(buttonArray.count) * distance)) / 2) + titleTextViewHeight!/2
            titleTextView?.center = CGPoint(x: cenX, y: cenY)
            animateTitleTextViewToNewPosition(titleTextView!, pos: CGPoint(x: deviceWidth/2, y: cenY), show: true)
            break
        case .SlideFromRight:
            let cenX = deviceWidth + titleTextViewWidth/2
            let cenY = ((deviceHeight - (CGFloat(buttonArray.count) * buttonHeight + CGFloat(buttonArray.count) * distance)) / 2) + titleTextViewHeight!/2
            titleTextView?.center = CGPoint(x: cenX, y: cenY)
            animateTitleTextViewToNewPosition(titleTextView!, pos: CGPoint(x: deviceWidth/2, y: cenY), show: true)
            break
        }
    }
    
    private func showAllButtons() {
        var count: CGFloat = 0
    
        if presentStyle == .DropUpFromBottom { buttonArray = buttonArray.reverse() }
        
        var slideStartPoint: CGFloat = 0
        if presentStyle == .SlideFromLeft || presentStyle == .SlideFromRight {
            if titleTextView != nil {
                slideStartPoint = ((deviceHeight - (CGFloat(buttonArray.count) * buttonHeight + CGFloat(buttonArray.count) * distance)) / 2) + titleTextViewHeight! + distance
            } else {
                slideStartPoint = (deviceHeight - (CGFloat(buttonArray.count) * buttonHeight + CGFloat(buttonArray.count-1) * distance)) / 2
            }
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
            }
            self.view.bringSubviewToFront(button)
            count++
        }
        actionSheetState = .Show
        delegate?.dvActionSheetDidAppear?(dvActionSheet: self)
    }
    
//    private func hideTitleTextViewAndAllButtons() {
//        //if titleTextView != nil { hideTitleTextView() }
//        //hideAllButtons()
//        
//        UIView.animateWithDuration(0.3, animations: {
//            self.view.alpha = 0
//            }, completion: { finished in
//                self.actionSheetState = .Hide
//                self.buttonArray.removeAll(keepCapacity: false)
//                self.view.removeFromSuperview()
//                self.removeFromParentViewController()
//                self.didMoveToParentViewController(nil)
//                self.delegate?.dvActionSheetDidDisappear?(dvActionSheet: self)
//        })
//    }
    
//    private func hideTitleTextView() {
//        switch(presentStyle) {
//        case .DropDownFromTop:
//            animateTitleTextViewToNewPosition(titleTextView!, pos: CGPoint(x: titleTextView!.center.x, y: -titleTextViewHeight!/2), show: false)
//        case .DropUpFromBottom:
//            animateTitleTextViewToNewPosition(titleTextView!, pos: CGPoint(x: titleTextView!.center.x, y: deviceHeight + titleTextViewHeight!/2), show: false)
//        case .SlideFromLeft:
//            animateTitleTextViewToNewPosition(titleTextView!, pos: CGPoint(x: -titleTextViewWidth/2, y: titleTextView!.center.y), show: false)
//        case .SlideFromRight:
//            animateTitleTextViewToNewPosition(titleTextView!, pos: CGPoint(x: deviceWidth + titleTextViewWidth/2, y: titleTextView!.center.y), show: false)
//        }
//    }
    
//    private func hideAllButtons() {
//        for var i=0; i<buttonArray.count; i++ {
//            let button: DVActionSheetButton = buttonArray[i] as DVActionSheetButton
//            switch(presentStyle) {
//            case .DropDownFromTop:
//                animateButtonToNewPosition(button, pos: CGPoint(x: button.center.x, y: -buttonHeight/2), show: false)
//            case .DropUpFromBottom:
//                animateButtonToNewPosition(button, pos: CGPoint(x: button.center.x, y: deviceHeight + buttonHeight/2), show: false)
//            case .SlideFromLeft:
//                animateButtonToNewPosition(button, pos: CGPoint(x: -buttonWidth/2, y: button.center.y), show: false)
//            case .SlideFromRight:
//                animateButtonToNewPosition(button, pos: CGPoint(x: deviceWidth + buttonWidth/2, y: button.center.y), show: false)
//            }
//        }
//    }
    
    private func animateButtonToNewPosition(button: DVActionSheetButton, pos: CGPoint, show: Bool) {
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            button.center = pos
            }, completion: { finished in
                if !show { button.removeFromSuperview() }
                else { self.addConstraintForButton(button, animationType: self.presentStyle) }
        })
    }
    
    private func animateTitleTextViewToNewPosition(textView: UITextView, pos: CGPoint, show: Bool) {
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            textView.center = pos
            }, completion: { finished in
                if !show {
                    textView.removeFromSuperview()
                    self.titleTextView = nil
                }
                else { self.addConstraintForTitleTextView(self.presentStyle) }
        })
    }
    
    // MARK: - Auto Layout Methods
    
    func addConstraintForButton(button: DVActionSheetButton, animationType: DVActionSheetPresentStyle ) {
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left , relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: self.distance))
        self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Right , relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -self.distance))
        self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height , relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: self.buttonHeight))
        
        if animationType == .DropDownFromTop {
            let dis = CGRectGetMinY(button.frame)
            self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top , relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: dis))
        } else if animationType == .DropUpFromBottom {
            let dis = CGRectGetMaxY(button.frame) - self.deviceHeight
            self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom , relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: dis))
        } else {
            self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            let startPoint = -(deviceHeight/2 - CGRectGetMidY(button.frame))
            self.view.addConstraint(NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterYWithinMargins, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterYWithinMargins, multiplier: 1.0, constant:startPoint))
        }
    }
    
    func addConstraintForTitleTextView(animationType: DVActionSheetPresentStyle) {
        titleTextView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: titleTextView!, attribute: NSLayoutAttribute.Left , relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: self.distance))
        self.view.addConstraint(NSLayoutConstraint(item: titleTextView!, attribute: NSLayoutAttribute.Right , relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -self.distance))
        self.view.addConstraint(NSLayoutConstraint(item: titleTextView!, attribute: NSLayoutAttribute.Height , relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: self.titleTextViewHeight!))
        
        if animationType == .DropDownFromTop {
            let dis = CGRectGetMinY(titleTextView!.frame)
            self.view.addConstraint(NSLayoutConstraint(item: titleTextView!, attribute: NSLayoutAttribute.Top , relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: dis))
        } else if animationType == .DropUpFromBottom {
            let dis = CGRectGetMaxY(titleTextView!.frame) - self.deviceHeight
            self.view.addConstraint(NSLayoutConstraint(item: titleTextView!, attribute: NSLayoutAttribute.Bottom , relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: dis))
        } else {
            self.view.addConstraint(NSLayoutConstraint(item: titleTextView!, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            let startPoint = -(deviceHeight/2 - CGRectGetMidY(titleTextView!.frame))
            self.view.addConstraint(NSLayoutConstraint(item: titleTextView!, attribute: NSLayoutAttribute.CenterYWithinMargins, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterYWithinMargins, multiplier: 1.0, constant:startPoint))
        }
        
    }
    
    // MARK: - Supporting Methods
    
    private func addVibrancyEffectToView(currentView: UIView) {
        let blurE: UIBlurEffect = UIBlurEffect(style: .Dark)
        let blurV: UIVisualEffectView = UIVisualEffectView(effect: blurE)
        blurV.frame = currentView.frame
        blurV.translatesAutoresizingMaskIntoConstraints = false
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
//        if button.index == buttonArray.count-1 { hideAllComponents() }
        hideAllComponents()
        delegate?.dvActionSheet?(dvActionSheet: self, didClickButtonAtIndex: button.index!)
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

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.nextResponder()
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}


