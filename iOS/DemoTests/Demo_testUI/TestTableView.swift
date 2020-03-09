//
//  TestTableView.swift
//  Demo_testUI
//
//  Created by Lydire on 2020/2/27.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation

class TestTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
  func add() {
      self.delegate = self
      self.dataSource = self
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
      header.backgroundColor = UIColor.red
      return header
  }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
