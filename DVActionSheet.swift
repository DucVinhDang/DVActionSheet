//
//  DVActionSheet.swift
//  DVActionSheetExample
//
//  Created by Đặng Vinh on 5/12/15.
//  Copyright (c) 2015 DVISoft. All rights reserved.
//

import UIKit

@objc protocol DVActionSheetDelegate {
    optional func dvActionSheet(dvActionSheet: DVActionSheet, didClickButtonAtIndex: Int)
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

    var delegate: DVActionSheetDelegate?
    var presentStyle = DVActionSheetPresentStyle.DropUpFromBottom
    var actionSheetState = DVActionSheetState.Hide
    var buttonArray = [DVActionSheetButton]()
    
    let deviceWidth = UIScreen.mainScreen().bounds.width
    let deviceHeight = UIScreen.mainScreen().bounds.height
    let buttonWidth: CGFloat = UIScreen.mainScreen().bounds.width - 10
    let buttonHeight: CGFloat = 43
    
    let buttonFont = UIFont(name: "Helvetica", size: 16)
    let buttonTitleColor = UIColor.whiteColor()
    let buttonBackgroundColor = UIColor(red: 0.404, green: 0.827, blue: 0.882, alpha: 1.0)
    let buttonHightLightBackgroundColor = UIColor(red: 0.333, green: 0.690, blue: 0.780, alpha: 1.9)
    let buttonCornerRadius: CGFloat = 0
    let distance: CGFloat = 5
    
    // MARK: - Init Methods
    
    init(title: String, delegate: DVActionSheetDelegate?, cancelButtonTitle: String, destructiveButtonTitle: String) {
        super.init(nibName: nil, bundle: nil)
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
//        setupContainerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup View Methods
    
    private func setupView() {
        view.frame = UIScreen.mainScreen().bounds
        view.backgroundColor = UIColor.clearColor()
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
    }
    
    // MARK: - Add Buttons Methods
    
    private func addActionSheetWithTitle(#title: String, delegate: DVActionSheetDelegate?, cancelButtonTitle: String, destructiveButtonTitle: String) {
    }
    
    private func addActionSheetWithTitle(#title: String, delegate: DVActionSheetDelegate?, cancelButtonTitle: String, destructiveButtonTitle: String, otherButtonTitles: [String]?) {
        if !destructiveButtonTitle.isEmpty { addDestructiveButtonWithTitle(title: destructiveButtonTitle) }
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
        view.addSubview(button)
        buttonArray.append(button)
    }
    
    private func addCancelButtonWithTitle(#title: String) {
        var button = DVActionSheetButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        button.center = CGPointMake(deviceWidth/2, deviceHeight + buttonHeight/2)
        button.dvActionSheetButtonType = .Cancel
        button.setAttributesForCancelButton(title: title)
        button.addTarget(self, action: Selector("cancelButtonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        buttonArray.append(button)
    }
    
    private func addDestructiveButtonWithTitle(#title: String) {
        var button = DVActionSheetButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        button.center = CGPointMake(deviceWidth/2, deviceHeight + buttonHeight/2)
        button.dvActionSheetButtonType = .Destructive
        button.setAttributesForDestructiveButton(title: title)
        view.addSubview(button)
        buttonArray.append(button)
    }
    
    // MARK: - Animation Methods
    
    func show(#target: UIViewController, style: DVActionSheetPresentStyle?) {
        if actionSheetState == .Show { return }
        target.addChildViewController(self)
        target.view.addSubview(self.view)
        didMoveToParentViewController(target)
        addVibrancyEffectToView(view)
        presentStyle = style!
        showAllButtons()
    }
    
    private func hide() {
        if actionSheetState == .Hide { return }
        hideAllButtons() { finished in
            self.actionSheetState = .Hide
            self.buttonArray.removeAll(keepCapacity: false)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            self.didMoveToParentViewController(nil)
        }

    }
    
    private func showAllButtons() {
        var count: CGFloat = 0
        view.alpha = 0
        UIView.animateWithDuration(0.2, animations: { self.view.alpha = 1 })
        if presentStyle == .DropUpFromBottom { buttonArray = buttonArray.reverse() }
        
        for button in buttonArray {
            switch(presentStyle) {
            case .DropDownFromTop:
                button.center = CGPoint(x: button.center.x, y: -buttonHeight/2)
                animateButtonToNewPosition(button, pos: CGPoint(x: button.center.x, y: self.distance*(count+1) + self.buttonHeight/2 + self.buttonHeight*count), show: true)

            case .DropUpFromBottom:
                button.center = CGPoint(x: button.center.x, y: deviceHeight + buttonHeight/2)
                animateButtonToNewPosition(button, pos: CGPoint(x: button.center.x, y: deviceHeight - self.distance*(count+1) - self.buttonHeight/2 - self.buttonHeight*count), show: true)
                
            case .SlideFromLeft:
                button.center = CGPoint(x: -buttonWidth/2, y: distance + buttonHeight/2)
                animateButtonToNewPosition(button, pos: CGPoint(x: distance + buttonWidth/2, y: self.distance*(count+1) + self.buttonHeight/2 + self.buttonHeight*count), show: true)
                
            case .SlideFromRight:
                button.center = CGPoint(x: deviceWidth + buttonWidth/2, y: distance + buttonHeight/2)
                animateButtonToNewPosition(button, pos: CGPoint(x: deviceWidth - distance - buttonWidth/2, y: self.distance*(count+1) + self.buttonHeight/2 + self.buttonHeight*count), show: true)
            default:
                break
            }
            self.view.bringSubviewToFront(button)
            count++
        }
        actionSheetState = .Show
    }
    
    private func hideAllButtons(completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.3, animations: { self.view.alpha = 0 })
        for button in buttonArray {
            switch(presentStyle) {
            case .DropDownFromTop:
                animateButtonToNewPosition(button, pos: CGPoint(x: button.center.x, y: -buttonHeight/2), show: false)
            case .DropUpFromBottom:
                animateButtonToNewPosition(button, pos: CGPoint(x: button.center.x, y: deviceHeight + buttonHeight/2), show: false)
            case .SlideFromLeft:
                animateButtonToNewPosition(button, pos: CGPoint(x: -buttonWidth/2, y: distance + buttonHeight/2), show: false)
            case .SlideFromRight:
                animateButtonToNewPosition(button, pos: CGPoint(x: deviceWidth + buttonWidth/2, y: distance + buttonHeight/2), show: false)
            default:
                break
            }
        }
        completion
    }
    
    private func animateButtonToNewPosition(button: DVActionSheetButton, pos: CGPoint, show: Bool) {
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            button.center = pos
            }, completion: { finished in
                if !show { button.removeFromSuperview() }
        })
    }
    
    // MARK: - Supporting Methods
    
    private func addVibrancyEffectToView(currentView: UIView) {
        let blurE: UIBlurEffect = UIBlurEffect(style: .Dark)
        let blurV: UIVisualEffectView = UIVisualEffectView(effect: blurE)
        blurV.frame = currentView.frame
        blurV.setTranslatesAutoresizingMaskIntoConstraints(false)
        currentView.addSubview(blurV)
    }
    
    // MARK: - Button Methods
    
    func cancelButtonAction(button: DVActionSheetButton) {
        hide()
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
