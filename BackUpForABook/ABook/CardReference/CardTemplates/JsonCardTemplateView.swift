//
//  JsonCardTemplateView.swift
//  ANBookPad
//
//  Created by dingf on 17/1/11.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

enum DesignTemplateStyle: Int {
    case multipleChoice_vertical = 1
    case multipleChoice_horizontal
    case match
}

// 组件类型
enum ComponentType: Int{
    case icon = 1
    case displayName
    case title
    case centerTableView
    case centerImageView
    case detail
    case info
}

class JsonCardTemplateView: CardTemplateView {
    override func key() -> String {
        return styleKey()
    }
    
    func styleKey() -> String {
        return vCard.cardStyleKey!
    }
    
    //var descriptionView = PlainCardView()
    
    // 1~5 vcard items
    //1
    var icon: UIImageView!
    var displayName: UILabel!
    //2
    var title: UILabel!
    //3
    var optionsTableView: UITableView!
    var centerImageView: UIImageView!
    //4
    var optionText: UILabel!
    //5
    var info: UILabel!
    
    var designStyle: DesignTemplateStyle?
    var viewWidth: CGFloat{
        get{
            return frame.size.width
        }
    }
    var viewHeight: CGFloat{
        get{
            return frame.size.height
        }
    }
    // MARK: ----- init -------
    
    init(frame: CGRect ,jsonDoc: String) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 156.0/255.0, green: 73.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        createRealTemplateView(jsonDoc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* 
        根据json file创建Templateview
        json文件中包含的数据:
        ["templateStyle"] -> DesignTemplateStyle.rawValue(match,horChoice,verChoice)
        ["subviewsFrame"] -> 所有subview的位置和大小信息
    */
    func createRealTemplateView(_ jsonFile: String){
        let data = jsonFile.data(using: String.Encoding.utf8)
        var dic = [String: Any]()
        do{
            dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
            if let style = dic["templateStyle"]{
                
                // 根据json file决定当前的style
                switch style as! Int {
                case DesignTemplateStyle.multipleChoice_vertical.rawValue:
                    designStyle = .multipleChoice_vertical
                    break
                case DesignTemplateStyle.multipleChoice_horizontal.rawValue:
                    designStyle = .multipleChoice_horizontal
                    break
                case DesignTemplateStyle.match.rawValue:
                    designStyle = .match
                    break
                default:
                    break
                }
                
                let dicsArray = dic["subviewsFrame"] as! [[String: Any]]
                for dic in dicsArray{
                    let originX = floor(viewWidth * (dic["originX"] as! CGFloat))
                    let originY = floor(viewHeight * (dic["originY"] as! CGFloat))
                    let width = floor(viewWidth * (dic["width"] as! CGFloat))
                    let height = floor(viewHeight * (dic["height"] as! CGFloat))
                    switch dic["componentType"] as! Int {
                    case ComponentType.icon.rawValue:
                        icon = UIImageView(frame: CGRect(x: originX, y: originY, width: width, height: height))
                        icon.backgroundColor = UIColor.white
                        icon.image = UIImage(named: "threePerson")
                        icon.tag = ComponentType.icon.rawValue
                        addSubview(icon)
                        break
                        
                    case ComponentType.displayName.rawValue:
                        displayName = UILabel(frame: CGRect(x: originX, y: originY, width: width, height: height))
                        
                        displayName.backgroundColor = UIColor(red: 58.0/255.0, green: 143.0/255.0, blue: 172.0/255.0, alpha: 1.0)
                        displayName.textAlignment = .center
                        displayName.text = "Age"
                        displayName.textColor = UIColor.white
                        displayName.numberOfLines = 0
                        displayName.adjustsFontSizeToFitWidth = true
                        displayName.tag = ComponentType.displayName.rawValue
                        addSubview(displayName)
                        break
                        
                    case ComponentType.title.rawValue:
                        title = UILabel(frame: CGRect(x: originX, y: originY, width: width, height: height))
                        title.textAlignment = .right
                        title.textColor = UIColor.black
                        title.text = "Biological information"
                        title.backgroundColor = UIColor.clear
                        title.numberOfLines = 0
                        title.adjustsFontSizeToFitWidth = true
                        title.tag = ComponentType.title.rawValue
                        addSubview(title)
                        break
                        
                    case ComponentType.centerTableView.rawValue:
                        optionsTableView = UITableView(frame: CGRect.init(x: originX, y: originY, width: width, height: height), style: .plain)
                        optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
                        optionsTableView.layer.cornerRadius = 0.05 * viewWidth
                        optionsTableView.layer.masksToBounds = true
                        optionsTableView.delegate = self
                        optionsTableView.dataSource = self
                        optionsTableView.backgroundColor = UIColor(red: 58.0/255.0, green: 143.0/255.0, blue: 172.0/255.0, alpha: 1.0)
                        if style as! Int == DesignTemplateStyle.multipleChoice_horizontal.rawValue {
                            optionsTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat(M_PI_2)))
                            optionsTableView.frame = CGRect.init(x: originX, y: originY, width: width, height: height)
                        }
                        optionsTableView.tag = ComponentType.centerTableView.rawValue
                        addSubview(optionsTableView)
                        break
                        
                    case ComponentType.centerImageView.rawValue:
                        centerImageView = UIImageView(frame: CGRect(x: originX, y: originY, width: width, height: height))
                        centerImageView.image = UIImage(named: "onePerson")
                        centerImageView.layer.cornerRadius = 0.05 * viewWidth
                        centerImageView.layer.masksToBounds = true
//                        centerImageView.layer.rasterizationScale = UIScreen.main.scale
                        centerImageView.tag = ComponentType.centerImageView.rawValue
                        addSubview(centerImageView)
                        break
                        
                    case ComponentType.detail.rawValue:
                        optionText = UILabel(frame: CGRect(x: originX, y: originY, width: width, height: height))
                        optionText.text = "The US census lists the category middle age from 45 to 65"
                        optionText.textColor = UIColor.black
                        optionText.backgroundColor = UIColor.clear
                        optionText.numberOfLines = 0
                        optionText.adjustsFontSizeToFitWidth = true
                        optionText.tag = ComponentType.detail.rawValue
                        
                        addSubview(optionText)
                        
                        break
                        
                    case ComponentType.info.rawValue:
                        info = UILabel(frame: CGRect(x: originX, y: originY, width: width, height: height))
                        info.textColor = UIColor.black
                        info.backgroundColor = UIColor.clear
                        info.numberOfLines = 0
                        info.text = "Physical characteristics"
                        info.adjustsFontSizeToFitWidth = true
                        info.tag = ComponentType.info.rawValue
                        addSubview(info)
                        break
                        
                    default:
                        break
                    }
                }
            }
        }catch let error as NSError{
            print("Can not convert json file to dic! Error:\(error)")
        }
    }
    
    // data
    override func setCardContent(_ card: CardInfoObjModel, defaultSelection: CardOptionObjModel?) {
        super.setCardContent(card, defaultSelection: defaultSelection)
        setRealData()
    }
    
    func setRealData() {
        if vCard.imageObj != nil{
            icon.image = vCard.imageObj
        }
        if vCard.displayName != nil{
            displayName.text = vCard.displayName!
        }
        if vCard.title != nil{
            title.text                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                = vCard.title
        }
        if vCard.info != nil{
            info.text = vCard.info
        }
        if vCard.cardOptions.isEmpty == false {
            optionText.text = vCard.cardOptions[0].match?.text
        }
        
        if designStyle == DesignTemplateStyle.match {
            if vCard.cardOptions.isEmpty == false {
                centerImageView.image = vCard.cardOptions[0].match?.imageObj
            }
        }
    }
}

extension JsonCardTemplateView: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let card = vCard{
            if vCard.cardOptions.isEmpty == false {
                return vCard.cardOptions.count
            }else{
                return 0
            }
        }else{
            return 4
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if vCard != nil{
            cell.imageView?.image = vCard.cardOptions[indexPath.row].match?.imageObj
            cell.textLabel?.text = vCard.cardOptions[indexPath.row].match?.text
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.backgroundColor = UIColor.clear
            if designStyle == .multipleChoice_horizontal{
                cell.contentView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            }
        }else{
            cell.imageView?.image = UIImage(named: "age")
            cell.textLabel?.text = "option's statement"
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.backgroundColor = UIColor.clear
            if designStyle == .multipleChoice_horizontal{
                cell.contentView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if designStyle == .multipleChoice_vertical{
            if vCard != nil {
                return optionsTableView.frame.size.height / CGFloat(vCard.cardOptions.count)
            }else{
                return optionsTableView.frame.size.height / 4
            }
            
        }else{
            if vCard != nil{
                return optionsTableView.frame.size.width / CGFloat(vCard.cardOptions.count)
            }else{
                return optionsTableView.frame.size.height / 4
            }
            
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        optionText.text = vCard.cardOptions[indexPath.row].match?.text
    }
}

