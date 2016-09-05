//
//  SessionViewController.swift
//  FiftyMeters
//
//  Created by Manish Anand on 03/09/16.
//  Copyright © 2016 Manish Anand. All rights reserved.
//

import UIKit
import CoreData
class SessionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var sessionTable = UITableView()
    var listItems = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionTable?.reloadData()
        sessionTable!.delegate = self
        sessionTable!.dataSource = self
        sessionTable!.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        //reload table
       
       
        //fetch result from core data
        let appDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Session")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            listItems = results as! [NSManagedObject]
             //self.sessionTable!.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }

    func update()  {
        sessionTable = UITableView()
        
        let appDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Session")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            listItems = results as! [NSManagedObject]
            //self.sessionTable!.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        self.sessionTable?.reloadData()
//        self.sessionTable!.delegate = self
//        self.sessionTable!.dataSource = self
//        self.sessionTable!.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //rows in table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewWillAppear(true)
        return listItems.count
    }
    
    //cell data
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.update()
        let cell = tableView.dequeueReusableCellWithIdentifier("eligibilityCell", forIndexPath: indexPath)
        let person = listItems[indexPath.row]
        
        
            //get current date
        let date = person.valueForKey("date") as! NSDate
        let dateShow = NSDateFormatter()
        dateShow.dateFormat = "E, d MMM yyyy HH:mm:ss"
        
            //set data in cell
        let timeLineLabel: UILabel = self.view.viewWithTag(11) as! UILabel
        timeLineLabel.text = " \(indexPath.row + 1).  \(dateShow.stringFromDate(date))"
       // timeLineLabel.text = dateShow.stringFromDate(date)
        return cell
    }
    
    //section in table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //heading of section
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Timeline (50 meters crossed)"
    }
 

}
