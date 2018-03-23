//
//  IntroPageArticlesViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/11.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class IntroPageArticlesViewController: UIViewController {
    fileprivate var articles = [ArticleObjModel]()
    fileprivate var articleAccess: ArticleAccess!
    fileprivate var spinner: UIActivityIndicatorView!
    let riskMetricKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spinner = StartSpinner(view)
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        
        articles = AIDMetricCardsCollection.standardCollection.getArticlesForRiskClass(riskMetricKey)
        if articleAccess == nil && articles.count == 0 {
            articleAccess = ArticleAccess(callback: self)
            articleAccess.getOneByPage(Int(arc4random() % 6), pageSize: 6)
        }else {
            createTable()
        }
    }
        
    func createTable()  {
        EndSpinner(spinner)
        
        let table = IntroArticalsTableView.createWithFrame(mainFrame, articles: articles)
        table.hostNavi = navigationController
        view.addSubview(table)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = ""
        title = "Articles"
    }
}

extension IntroPageArticlesViewController: DataAccessProtocal {
    func didFinishGetAttribute(_ obj: [AnyObject]) {
        if obj is [ArticleObjModel] {
            articles = obj as! [ArticleObjModel]
            AIDMetricCardsCollection.standardCollection.saveArticles(articles, forRiskClass: riskMetricKey)
            createTable()
        }
    }
    
    func failedGetAttribute(_ error: String) {
        let errorAlert = UIAlertController(title: "Error!!!", message: "No Data For Article Now", preferredStyle: .alert)
//        let reloadAction = UIAlertAction(title: "Reload", style: .default, handler: { (action) in
//            self.articleAccess.getOneByPage(Int(arc4random() % 6), pageSize: 6)
//        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        })
        
        errorAlert.addAction(cancelAction)
//        errorAlert.addAction(reloadAction)
        present(errorAlert, animated: true, completion: nil)
    }
}
