//
//  HistoryViewController.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/23.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import UIKit
import CoreBluetooth

class HistoryViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    var resultData: [String: TWRResult]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController!.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.twinkrunBlack()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        tableView.layoutIfNeeded()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = documentsPath.stringByAppendingPathComponent("TWRResultData2")
        resultData = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [String: TWRResult]
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let resultData = resultData {
            return resultData.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 240
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("resultCell") as UITableViewCell
        
        cell.backgroundColor = UIColor.twinkrunBlack()
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        
        var view = cell.viewWithTag(1)!
        
        let key = resultData!.keys.array[indexPath.row]
        let result = resultData![key]!
        var graphColor = result.score < 1000 ? UIColor.twinkrunRed() : UIColor.twinkrunGreen()
        var gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            graphColor.colorWithAlphaComponent(0.2).CGColor,
            graphColor.CGColor
        ]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        var graph:BEMSimpleLineGraphView = cell.viewWithTag(2) as BEMSimpleLineGraphView
        
        graph.delegate = result
        graph.dataSource = result
        
        graph.enablePopUpReport = true
        graph.enableReferenceAxisLines = true
        graph.colorBackgroundXaxis = UIColor.whiteColor()
        graph.colorTop = UIColor.clearColor()
        graph.colorBottom = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        graph.colorLine = UIColor.whiteColor()
        
        var dateLabel = cell.viewWithTag(3) as UILabel
        dateLabel.text = key
        
        var scoreLabel = cell.viewWithTag(4) as UILabel
        scoreLabel.text = "\(NSNumberFormatter.localizedStringFromNumber(result.score, numberStyle: .DecimalStyle)) Point"
        
        return cell
    }
}