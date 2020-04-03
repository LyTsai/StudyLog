//
//  DeviceImageGetTool.swift
//  Demo_testUI
//
//  Created by Lydire on 2020/2/24.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation
import UIKit

/*
1. Use Camera: info.plist, Privacy - Camera Usage Description
2. ViewController  -> rootViewController
    如果是加在window上，必须用root才能出来，一般情况下，是sender的viewController
*/
class DeviceImageGetTool: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imageIsChosen: ((UIImage) -> Void)?
    var selectionIsCancelled: (() -> Void)?
    weak var viewControllerForPresent: UIViewController?
    
    // sheet
    var sheetTitle = "Choose From"
    var sheetMessage: String?
    var allowedTypes: [(title: String, type: UIImagePickerController.SourceType)] = [("PhotoLibrary", .photoLibrary), ("Saved Photos Album", .savedPhotosAlbum), ("Camera", .camera)]
    // image handle
    var allowsEditing = true

    var confinedLength: CGFloat?
    
    // methods
    func getImageFromAllowedTypes(_ sender: UIView) {
        if self.allowedTypes.count == 1 {
            // only one
            showImagePicker(self.allowedTypes.first!.type)
        }else {
            // multiple choice
            let actionSheet = UIAlertController(title: sheetTitle, message: sheetMessage, preferredStyle: .actionSheet)
            for (title, type) in self.allowedTypes {
                let alertAction = UIAlertAction(title: title, style: .default) { (action) in
                     self.showImagePicker(type)
                }
                actionSheet.addAction(alertAction)
            }
            actionSheet.popoverPresentationController?.sourceView = sender // iPad, 从sender显示sheet
            actionSheet.popoverPresentationController?.sourceRect = sender.bounds
            viewControllerForPresent?.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func showImagePicker(_ sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = allowsEditing // square
                   
            viewControllerForPresent?.present(imagePicker, animated: true, completion: nil)
        }else {
            // no camera
            viewControllerForPresent?.showAlertMessage(nil, title: "SourceType Is Not Available", buttons: [("Choose Other Source Type", nil)])
        }
    }
    
    // delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var resultInfoKey = UIImagePickerController.InfoKey.originalImage
        if allowsEditing {
            resultInfoKey = UIImagePickerController.InfoKey.editedImage
        }
        
        var image = info[resultInfoKey] as! UIImage
        if confinedLength != nil && image.size.width > confinedLength! {
            image = image.changeImageSizeTo(CGSize(width: confinedLength!, height: confinedLength!))
        }
    
        picker.dismiss(animated: true) {
            self.imageIsChosen?(image)
        }
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.selectionIsCancelled?()
        }
    }
}
