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
                /*默认情况下, UIKit根据目标打印机和打印作业的输出类型设置一组默认的纸张大小. 如, 根据UIPrintInfo中的output type来指定. 例如, 如果输出是类型UIPrintInfoOutputPhoto, 默认纸张大小是4x6英寸, A6或其他一些标准, 这和当地的一些标准有关. 如果输出类型是UIPrintInfoOutputGeneral或UIPrintInfoOutputGray, 则默认大小是US 字母(8 1/2x11英寸), A4或一些其他标准的大小设置.
                 */
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
