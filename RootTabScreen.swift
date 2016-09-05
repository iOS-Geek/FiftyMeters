//
//  RootTabScreen.swift
//  FiftyMeters
//
//  Created by Manish Anand on 05/09/16.
//  Copyright © 2016 Manish Anand. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
class RootTabScreen: UITabBarController, CLLocationManagerDelegate {
 
    var updateOnce : Bool = false
    var LocationManagerLink : CLLocationManager?
    var firstLocation : CLLocation?
    var secondLocation : CLLocation?
    var distance : Double = 0
    var totalDistance : Double = 0
  
    var locationLatitude: Float = 0.0
    var locationLongitude: Float = 0.0
    var storeOnce : Bool = true
    let DistanceScreen = SecondViewController()
    var listsItems = [NSManagedObject]()
    var firstTab : UIViewController?
    var secondTab : UIViewController?
    var thirdTab : UIViewController?
    var database = SessionViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
    //Threes tabs
        firstTab = self.viewControllers![0] as UIViewController
        secondTab = self.viewControllers![1] as UIViewController
        thirdTab = self.viewControllers![2] as UIViewController
    
    //initializing location manager
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .Denied {
                self.basicAlert("Please allow location access to use this app. Please login again", title: "Location Eroor")
            }
            else{
            LocationManagerLink = CLLocationManager()
            LocationManagerLink?.delegate = self
            LocationManagerLink?.desiredAccuracy = kCLLocationAccuracyBest
           // LocationManagerLink?.distanceFilter = 1
            LocationManagerLink?.requestWhenInUseAuthorization()
            self.updateOnce = true
            self.LocationManagerLink?.startUpdatingLocation()
            
            }
            
        }

 
    }
    
    override func viewWillAppear(animated: Bool) {

    }
    func saveName(date : NSDate) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Session", inManagedObjectContext:managedContext)
        let timeStored = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //storing value
        timeStored.setValue(date, forKey: "date")

        do {
            try managedContext.save()
                listsItems.append(timeStored)
            let table = self.thirdTab?.view.viewWithTag(10) as! UITableView
            table.reloadData()

            self.update()
        } catch let error as NSError  {
            print("Can not save \(error), \(error.userInfo)")
        }
    }
    
    func update()  {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //convert location to address
    func getLocationAddress(location:CLLocation)  {
        let geocoder = CLGeocoder()
        //print("My address")
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
            var placemark:CLPlacemark!
            
            if error == nil && placemarks!.count > 0 {
                placemark = placemarks![0] as CLPlacemark
                var addressString : String = ""
                    
                    if placemark.subThoroughfare != nil {
                        addressString += placemark.subThoroughfare! + " "
                    }
                    if placemark.thoroughfare != nil {
                        addressString += addressString + placemark.thoroughfare! + ", "
                    }
                    if placemark.subLocality != nil{
                        addressString += placemark.subLocality! + " "
                    }
                    if placemark.locality != nil {
                        addressString = addressString + placemark.locality! + ", "
                    }
                    if placemark.subAdministrativeArea != nil{
                        addressString += placemark.subAdministrativeArea! + " "
                    }
                    if placemark.administrativeArea != nil{//state
                        addressString += placemark.administrativeArea! + " "
                    }
                    if placemark.postalCode != nil {
                        addressString = addressString + placemark.postalCode! + " "
                    }
                    if placemark.country != nil {
                        addressString = addressString + placemark.country!
                    }
                //set address in first tab
                let addressLabel = self.firstTab?.view.viewWithTag(10) as! UILabel
                addressLabel.text = addressString

            }
        })
    }
    
    //location update method
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if ( updateOnce == true){
         
            
            //get address from location
            self.getLocationAddress(locations.last!)
            
            let locationArray = locations as Array?
            
            if firstLocation != nil{
                secondLocation = locationArray!.last
                distance = (secondLocation?.distanceFromLocation(firstLocation!))!
                totalDistance += distance
              
            }//first location method ends
            
            //check if user travelled 50 mtrs
            if totalDistance > 50{
                if storeOnce == true{
                    storeOnce = false
                    let currentDate = NSDate()
                    self.saveName(currentDate)
                   
                    self.basicAlert("", title: "You have travelled 50 meters.")
                    let table = self.thirdTab?.view.viewWithTag(10) as! UITableView
                    table.reloadData()
                }
            }
            
             //print distance travelled in second tab
            let lbl = self.secondTab?.view.viewWithTag(10) as! UILabel
            lbl.text = "\(round(totalDistance)) mtrs"

            //get first location
            firstLocation = locationArray?.last

            
        }//update once
    }
   
    
    //Basic alert for message showing
    func basicAlert(message:String , title : String)  {
        let alert=UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in //
          
        }));
        if ((self.navigationController?.visibleViewController?.isKindOfClass(UIAlertController)) == nil){
            self.presentViewController(alert, animated: true, completion: {
              
                
                
            })
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        //print(error.localizedDescription)
        }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
       // print(status.rawValue)
        switch status {
        case .AuthorizedAlways:
            break
            
        case .AuthorizedWhenInUse:
            break
        case .Denied:
            //self.serverErrorAlert()
            break
        case .NotDetermined:
            break
            
        case .Restricted:
            break
  
        }
    }
    
    
}
