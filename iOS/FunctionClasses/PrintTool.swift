//
//  PrintTool.swift
//  Demo_testUI
//
//  Created by L on 2020/2/24.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation

/*
 UIPrintInteractionControllerDelegate
 */

class PrintTool {
    var jobName: String = "Print For App"
    
    func printView(_ view: UIView) {
        if let viewData = view.createImageCopy()?.pngData() {
            printData(viewData)
        }
    }
    
    func printData(_ printData: Data) {
        if UIPrintInteractionController.isPrintingAvailable {
            if UIPrintInteractionController.canPrint(printData) {
                let printInfo = UIPrintInfo(dictionary: nil)
                printInfo.outputType = .photo // general, grayScale
                printInfo.jobName = jobName
//                printInfo.orientation = .portrait // default is portait
                
                // print
                let printController = UIPrintInteractionController.shared
                printController.printInfo = printInfo
                printController.showsNumberOfCopies = true
                printController.printingItem = printData
                printController.present(animated: true, completionHandler: nil)
            }else {
                rootViewController?.showAlertMessage(nil, title: "Can't Print Data", buttons: [("OK", nil)])
            }
        }else {
            // not available
            rootViewController?.showAlertMessage(nil, title: "It Is Not Printing Available", buttons: [("OK", nil)])
        }
    }
}
