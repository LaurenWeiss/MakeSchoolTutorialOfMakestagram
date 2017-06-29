//
//  Storyboard+Utility.swift
//  Makestagram
//
//  Created by Lauren Weiss on 6/27/17.
//  Copyright © 2017 Lauren Weiss. All rights reserved.
//

import Foundation

import UIKit

//extending UIStoryboard with the following enum

extension UIStoryboard {
    enum MGType: String {
        case main
        case login
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    //convenience initializer that makes use of the enum 
    //allows for the initialization of the correct storyboard based on each enum case
        convenience init (type: MGType, bundle: Bundle? = nil) {
            self.init(name: type.filename, bundle: bundle)
        }

    static func initialViewController(for type: MGType) -> UIViewController{
        //so that we no longer have to optionally unwrap the initial view controller and instead can use this convenience class method for getting a reference to the initial view controller of a storyboard
        //haven't implemented this yet...
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        return initialViewController
        }
    }
