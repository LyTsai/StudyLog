//
//  EmailOpearationTool.swift
//  Demo_testUI
//
//  Created by L on 2020/2/24.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation
import MessageUI

/*
 MFMailComposeViewControllerDelegate
 
 mailCompose.mailComposeDelegate = self
 */

class EmailOpearationTool: NSObject, MFMailComposeViewControllerDelegate {
    var subject: String?
    var recipient: String?
    var emailContent: String?
    var attachment: Data?
    
    func sendEmail() {
        // check email address
        
        // send
        if MFMailComposeViewController.canSendMail() {
            
            let mailCompose = MFMailComposeViewController()
            mailCompose.mailComposeDelegate = self

            mailCompose.setSubject("标题")
            mailCompose.setToRecipients(["收件人"]) // setCcRecipients, setBccRecipients

            let emailContent = "正文"
            mailCompose.setMessageBody(emailContent, isHTML: false)

            if attachment != nil {
                mailCompose.addAttachmentData(attachment!, mimeType: "", fileName: "order.png")
            }
            rootViewController?.present(mailCompose, animated: true, completion: nil)
        }else {
            rootViewController?.showAlertMessage("Please check your email account", title: "Can not send email to \(recipient)", buttons: [("OK", nil)])
        }
    }
   
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

 

