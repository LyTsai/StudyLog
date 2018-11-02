//
//  IntroArticalsView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/16.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// simple view for data fill
class IntroArticalsTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var articles = [ArticleObjModel]()
    weak var hostNavi: UINavigationController!
    class func createWithFrame(_ frame: CGRect, articles: [ArticleObjModel]) -> IntroArticalsTableView {
        let table = IntroArticalsTableView(frame: frame, style: .plain)
        table.articles = articles
        
        table.dataSource = table
        table.delegate = table
        
        return table
    }
    
    // data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = articles[indexPath.item]
        
        let cell = IntroRiskClassKnowledgeCell.cellWithTableView(tableView, article: article)
        return cell
    }
    
    // delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let web = IntroPageWebViewController()
        web.urlString = "http://106.14.136.77:82/v1.0/hr-cvd.html"
        if hostNavi != nil {
            hostNavi.pushViewController(web, animated: true)
        }
    }
}
