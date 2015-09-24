//
//  ViewController.swift
//  DVActionSheetExample
//
//  Created by Đặng Vinh on 5/12/15.
//  Copyright (c) 2015 DVISoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DVActionSheetDelegate {

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
        let dvActionSheet = DVActionSheet(title: "Đây là danh sách các chức năng mà hệ thống hỗ trợ, các chức năng đều đang trong quá trình thử nghiệm, xin mời bạn lựa chọn", delegate: self, cancelButtonTitle: "OK", destructiveButtonTitle: "Click")
        dvActionSheet.show(self, style: .DropUpFromBottom)
    }
    
    @IBAction func topAction(sender: AnyObject) {
        let dvActionSheet = DVActionSheet(title: "Đây là danh sách các chức năng mà hệ thống hỗ trợ, xin mời lựa chọn", delegate: self, cancelButtonTitle: "Exit", destructiveButtonTitle: "Touch it now", otherButtonTitles: ["A","B","C"])
        dvActionSheet.show(self, style: .DropDownFromTop)
    }
    
    @IBAction func leftAction(sender: AnyObject) {
        let dvActionSheet = DVActionSheet(title: "", delegate: self, cancelButtonTitle: "Exit", destructiveButtonTitle: "Touch it now", otherButtonTitles: ["A","B","C"])
        dvActionSheet.show(self, style: .SlideFromLeft)
    }

    @IBAction func rightAction(sender: AnyObject) {
        let dvActionSheet = DVActionSheet(title: "Đây là danh sách các chức năng mà hệ thống hỗ trợ, xin mời lựa chọn", delegate: self, cancelButtonTitle: "Exit", destructiveButtonTitle: "Touch it now", otherButtonTitles: ["A","B"])
        dvActionSheet.show(self, style: .SlideFromRight)
    }
    
    // MARK: - DVActionSheet Delegate
    
    func dvActionSheetWillAppear(dvActionSheet dvActionSheet: DVActionSheet) {
        print("Will Appear")
    }
    
    func dvActionSheetDidAppear(dvActionSheet dvActionSheet: DVActionSheet) {
        print("Did Appear")
    }
    
    func dvActionSheetWillDisappear(dvActionSheet dvActionSheet: DVActionSheet) {
        print("Will Disappear")
    }
    
    func dvActionSheetDidDisappear(dvActionSheet dvActionSheet: DVActionSheet) {
        print("Did Disappear")
    }
    
    func dvActionSheet(dvActionSheet dvActionSheet: DVActionSheet, didClickButtonAtIndex: Int) {
        switch(didClickButtonAtIndex) {
        case 0:
            print("Clicked on Destructive button")
        case 1:
            print("Clicked on button at index \(didClickButtonAtIndex)")
        case 2:
            print("Clicked on button at index \(didClickButtonAtIndex)")
        case 3:
            print("Clicked on button at index \(didClickButtonAtIndex)")
        case 4:
            print("Clicked on Cancel button")

        default:
            break;
        }
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
