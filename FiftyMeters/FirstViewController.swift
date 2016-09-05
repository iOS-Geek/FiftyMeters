//
//  FirstViewController.swift
//  FiftyMeters
//
//  Created by Manish Anand on 03/09/16.
//  Copyright © 2016 Manish Anand. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func viewWillAppear(animated: Bool) {
      
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

}







