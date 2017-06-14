//
//  FilePaths.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/25.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
/** path for impactful */
let planPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("planForMe.data")

/** path for easy */
let easyPlanPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("easyPlanForMe.data")
