//
//  MGPhotoHelper.swift
//  Makestagram
//
//  Created by Lauren Weiss on 6/28/17.
//  Copyright © 2017 Lauren Weiss. All rights reserved.
//

import UIKit

//The MGPhotoHelper presents the popover to allow the user to choose between
//taking a new photo or selecting one from the photo library
//Depending on the user's selection, presenting the camera or photo library
//Also returns the image that the user has taken or selected

class MGPhotoHelper: NSObject {

    //MARK: - Properties
    
    //called when the user has selected a photo from UIImagePickerController
    var completionHandler:((UIImage) -> Void)?
    
    //MARK: - Helper Methods
    
    //presents the dialog that allows users to choose between their cameras and their photo libraries
    func presentActionSheet(from viewController: UIViewController) {
        
        //UIAlertController can be used to present different types of alerts
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle : .actionSheet)
        
        //check if the current device has a camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { [unowned self]
                action in
                self.presentImagePickerController(with: .camera, from: viewController)
            })
            alertController.addAction(capturePhotoAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { [unowned self]action in
                    self.presentImagePickerController(with: .photoLibrary, from: viewController)
            })
            alertController.addAction(uploadAction)
        }
        //cancel action that allows the user to close the UIAlertController action sheet
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        //present the UIAlertController from our UIViewController
        viewController.present(alertController, animated: true)
}
    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        //create a new instance of UIImagePickerController; this object presents a native UI component
        //that will allow user to take photo from camera or choose existing image from library
        let imagePickerController = UIImagePickerController()
        //set sourceType to determine whether UIImagePickerController will activate camera and display a photo taking overlay or show the user's photo library
        imagePickerController.sourceType = sourceType
        
        
        //becoming the delegate of UIImagePickerController - now need to conform to some protocols
        //was originally imagePickerController.delegate = self ---but then that made the program crash
        imagePickerController.delegate = self
        
        viewController.present(imagePickerController, animated: true)
    }

}

extension MGPhotoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            completionHandler?(selectedImage)
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
