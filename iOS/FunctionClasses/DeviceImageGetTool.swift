//
//  DeviceImageGetTool.swift
//  Demo_testUI
//
//  Created by Lydire on 2020/2/24.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class DeviceImageGetTool: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imageIsChosen: ((UIImage) -> Void)?
    var selectionIsCancelled: (() -> Void)?
    
    // sheet
    var sheetTitle = "Choose From"
    var message: String?
    var allowedTypes: [(title: String, type: UIImagePickerController.SourceType)] = [("PhotoLibrary", .photoLibrary), ("Camera", .camera), ("Saved Photos Album", .savedPhotosAlbum)]
    // image handle
    var allowsEditing = true

    var confinedPoint: CGFloat?
    
    // methods
    func getImageFromAllowedTypes(_ sender: UIView) {
        let actionSheet = UIAlertController(title: sheetTitle, message: message, preferredStyle: .actionSheet)
        for (title, type) in self.allowedTypes {
            let alertAction = UIAlertAction(title: title, style: .default) { (action) in
                 self.showImagePicker(type)
            }
            actionSheet.addAction(alertAction)
        }
        actionSheet.popoverPresentationController?.sourceView = sender // iPad, 从sender显示sheet
        actionSheet.popoverPresentationController?.sourceRect = sender.bounds
        rootViewController?.present(actionSheet, animated: true, completion: nil)
    }
    
    func showImagePicker(_ sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = allowsEditing // square
                   
            rootViewController?.present(imagePicker, animated: true, completion: nil)
        }else {
            // no camera
            rootViewController?.showAlertMessage(nil, title: "SourceType Is Not Available", buttons: [("Choose Other Source Type", nil)])
        }
    }
    
    // delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var resultInfoKey = UIImagePickerController.InfoKey.originalImage
        if allowsEditing {
            resultInfoKey = UIImagePickerController.InfoKey.editedImage
        }
        
        var image = info[resultInfoKey] as! UIImage
        if confinedPoint != nil && image.size.width > confinedPoint! {
                image = image.changeImageSizeTo(CGSize(width: confinedPoint!, height: confinedPoint!))
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
