//
//  ViewController.swift
//  Demo_testUI
//
//  Created by iMac on 17/3/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "时间安排+清单+当天工作安排", withExtension: "csv") {
            do {
//                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let string = try String(contentsOf: url, encoding: .utf8)
                print(string)
            }catch {
                print("error")
            }
            
            
        }else {
            print( Bundle.main.bundleURL)
        }
       
        
        //先把excel的文件另存为csv格式的文件，然后在另存为txt格式的
//        let dataBase = DataBaseManager()
//        //读取txt文件
//        let path = Bundle.main.path(forResource: "openTimes", ofType: "txt")
//        let cfEnc = CFStringEncodings.GB_18030_2000
//        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
//        do {
//            let ret = try NSString.init(contentsOfFile: path!, encoding: enc)
//            let datas = ret .components(separatedBy:"\r")//\r代表换行，通过换行分割成一条条的数据，放入数组
//            for i in datas{
//                let arrs =  i .components(separatedBy:",")
//                openTimArr.append(arrs)
//            }
//            openTimArr.removeFirst()
//            for i in openTimArr{
//                let openDict = ["lotterycode":i[0],"issue_no":i[1],"single_letter":i[2],"open_time":i[3]]
//                //插入数据库
//                dataBase.insert(tableName: "tc_lottery_open_time", dataDic: openDict as NSDictionary)
//            }
//        }catch let error as NSError {
//            QL1(error)
//        }
    }
    

    @IBAction func actionForButton(_ sender: Any) {
//        let vc = AbookHintViewController()
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        vc.focusOnFrame(CGRect(x: 40, y: 160, width: 100, height: 200), hintText: "this is a test string") 
//        present(vc, animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
}

