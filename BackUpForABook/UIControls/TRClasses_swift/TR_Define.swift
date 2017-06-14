//
//  File.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/11.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import Foundation

// tree ring map object types
enum TRObjs: Int {
    case none           = 1
    case arrows_begin
    case arrows_end
    case columnBar
    case cell
    case column
    case column_line
    case column_axis
    case column_axis_label
    case rowBar
    case row
    case row_line
    case row_axis
    case row_axis_label
}

// tree ring hit test result
struct HitObj {
    var hitObject: TRObjs?   // type of object being hit
    var sliceIndex: Int?     // slice index of object being hit
    var col: Int?            // column of object being hit
    var row: Int?            // row of object being hit
}

enum GridLine: Int {
    case none              = 1
    case solid
    case dash
    case neon
}

enum TickLabelOrientation: Int {
    case zero              = 1
    case ninety
    case radius
    case angle
}

enum TRSliceRingBkg{
    case none
    case simple
    case metal
}

enum InnerDecoration {
    case none
    case blackGray
    case whiteBlack
}

enum BarPosition :Int {
    case none              = 1
    case leftOrTop
    case rightOrBottom
}

enum SliceBorder: Int {
    case none              = 1
    case line
    case solid
    case dash
    case pops
    case metal
}

struct Slice {
    var left: Float?
    var right: Float?
    var top: Float?
    var bottom: Float?
}

enum SliceViewStyle {
    case style_0
    case style_1
    case style_2
}


func DEGREETORADIANS(degree: Float) -> Float{
    return ((Float(M_PI) * degree) / 180)
}

enum CellValueShow: Int{
    case none   = 1
    case flat
    case flatGradient
    case _3d
}

enum CellValueShape: Int{
    case none   =  1
    case dot
    case cross
    case circle
    case image
}

let AGE             =   "Age"
let SKIN            =   "Skin Color"
let BODYFAT         =   "Body Fat"
let Environment     =   "Environment"
let Latitude        =   "Latitude"
let SUNExposure     =   "Sun Exposure"
let Season          =   "Season"
let Pregnancy       =   "Pregnancy"
let Diet            =   "Diet Pattern"
let DNA             =   "DNA"
let VITD            =   "Vit D3 level"
let Diseaases       =   "Diseases"
let Medications     =   "Medications"


enum AxisTickStyle: Int{
    case even           = 1
    case linear_MinMax
    case linear_MaxMin
}

enum TRMTextAlignment: Int{
    case none           = 1
    case left_top
    case left_bottom
    case right_top
    case right_bottom
}























