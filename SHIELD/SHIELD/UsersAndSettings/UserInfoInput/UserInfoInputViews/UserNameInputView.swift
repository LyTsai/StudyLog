//
//  LoginUserNameInputView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/5.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class UserNameInputView: DashBorderView, UITextFieldDelegate {
    // result
    var userName: String {
        return textField.text ?? ""
    }
    var userIcon: UIImage! {
        return avatar.image
    }
    
    // create
    fileprivate var textField = UITextField()
    fileprivate let avatar = UIImageView()
    fileprivate let cameraIcon = UIImageView()
    override func addBasicViews() {
        super.addBasicViews()
      
        // textField
        textField.layer.borderWidth = fontFactor * 3
        textField.layer.borderColor = tabTintGreen.cgColor
        textField.layer.cornerRadius = 5 * fontFactor
        
        textField.placeholder = "Name"
        textField.textColor = tabTintGreen
        textField.delegate = self
        textField.textAlignment = .center
        textField.clearButtonMode = .whileEditing
        
        // choose icon
        avatar.layer.borderWidth = fontFactor * 3
        cameraIcon.image = #imageLiteral(resourceName: "icon_camera")
        avatar.image = ProjectImages.sharedImage.tempAvatar
        avatar.layer.borderColor = UIColorFromHex(0xB2FF59).cgColor
        avatar.layer.masksToBounds = true
        avatar.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseAvatar))
        avatar.addGestureRecognizer(tap)
        
        // add
        addSubview(textField)
        addSubview(avatar)
        addSubview(cameraIcon)
    }
    
    func setName(_ name: String) {
        textField.text = name
    }
    
    func setIcon(_ image: UIImage) {
        avatar.image = image
    }
    
    @objc func chooseAvatar() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let aHeight = bounds.height * 0.28
        avatar.frame = CGRect(center: CGPoint(x: bounds.midX, y: aHeight), length: aHeight)

        avatar.layer.cornerRadius = aHeight * 0.5
        
        let cameraL = aHeight * 0.25
        cameraIcon.frame = CGRect(x: avatar.frame.maxX - cameraL, y: avatar.frame.maxY - cameraL, width: cameraL, height: cameraL)
        
        let xMargin = bounds.width * 0.1
        textField.frame = CGRect(x: xMargin, y: aHeight * 2, width: bounds.width - 2 * xMargin, height: bounds.height * 0.15)
        textField.font = UIFont.systemFont(ofSize: bounds.height * 0.05, weight: .semibold)
    }
    
    // keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
}

extension UserNameInputView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picker.dismiss(animated: true) {
            self.setIcon(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
        }
    }
}


