//
//  UIImage+Size.swift
//  Makestagram
//
//  Created by Lauren Weiss on 6/29/17.
//  Copyright © 2017 Lauren Weiss. All rights reserved.
//

import UIKit

extension UIImage {
    //computed property that will calculate the aspect height for the
    //instance of a UIImage based on the size property of an image
    var aspectHeight: CGFloat {
    let heightRatio = size.height / 736
    let widthRatio = size.width / 414
    let aspectRatio = fmax(heightRatio, widthRatio)
    
    return size.height / aspectRatio
    
}
}
