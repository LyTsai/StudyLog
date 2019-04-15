//
//  VisualMapViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/3/23.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VisualMapViewController: UIViewController {
    @IBOutlet weak var mapView: VisualMapView!
    
  
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.layoutIfNeeded()
        mapView.loadBoards()
    }

    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

