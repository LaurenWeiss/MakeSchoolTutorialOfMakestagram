//
//  MainTabBarController.swift
//  Makestagram
//
//  Created by Lauren Weiss on 6/28/17.
//  Copyright © 2017 Lauren Weiss. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    //creating an instance of the MGPhotoHelper object
    let photoHelper = MGPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this is a closure - which is baically a function without a name
        photoHelper.completionHandler = { image in
            print("handle image")
        }
        
        delegate = self
        tabBar.unselectedItemTintColor = .black
    }
    
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            //presenting the action sheet from the photoHelper that will allow the user
            //to capture a photo from their camera or upload a photo from their library
            photoHelper.presentActionSheet(from: self)
            return false
        }
        return true
    }
}
