//
//  SecondViewController.swift
//  DVActionSheetExample
//
//  Created by Đặng Vinh on 11/29/15.
//  Copyright © 2015 DVISoft. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, DVActionSheetDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let arr = ["A","B","C"]
    @IBOutlet weak var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
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
    
    @IBAction func handleBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = arr[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dvActionSheet = DVActionSheet(title: "Đây là danh sách các chức năng mà hệ thống hỗ trợ, các chức năng đều đang trong quá trình thử nghiệm, xin mời bạn lựa chọn", delegate: self, cancelButtonTitle: "OK", destructiveButtonTitle: "Click")
        dvActionSheet.showInView(self.view, style: .DropUpFromBottom)
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
