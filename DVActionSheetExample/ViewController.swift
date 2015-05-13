//
//  ViewController.swift
//  DVActionSheetExample
//
//  Created by Đặng Vinh on 5/12/15.
//  Copyright (c) 2015 DVISoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bottomAction(sender: AnyObject) {
        var dvActionSheet = DVActionSheet(title: "", delegate: nil, cancelButtonTitle: "Exit", destructiveButtonTitle: "Touch it now", otherButtonTitles: ["A","B","C"])
        dvActionSheet.show(target: self, style: .DropUpFromBottom)
    }
    
    @IBAction func topAction(sender: AnyObject) {
        var dvActionSheet = DVActionSheet(title: "", delegate: nil, cancelButtonTitle: "Exit", destructiveButtonTitle: "Touch it now", otherButtonTitles: ["A","B","C"])
        dvActionSheet.show(target: self, style: .DropDownFromTop)
    }
    
    @IBAction func leftAction(sender: AnyObject) {
        var dvActionSheet = DVActionSheet(title: "", delegate: nil, cancelButtonTitle: "Exit", destructiveButtonTitle: "Touch it now", otherButtonTitles: ["A","B","C"])
        dvActionSheet.show(target: self, style: .SlideFromLeft)
    }

    @IBAction func rightAction(sender: AnyObject) {
        var dvActionSheet = DVActionSheet(title: "", delegate: nil, cancelButtonTitle: "Exit", destructiveButtonTitle: "Touch it now", otherButtonTitles: ["A","B","C"])
        dvActionSheet.show(target: self, style: .SlideFromRight)
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
