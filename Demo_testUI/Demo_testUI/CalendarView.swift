//
//  CalendarView.swift
//  ANBookPad
//
//  Created by dingf on 16/9/9.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

class CalendarView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource{
    //可变的日期
    var date :Date!
    //今天的日期
    var today :Date!
    var loadFinished = false
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!

    lazy var weekDayArr = {
        return Array<String>()
    }()
    var myMaskView :UIView!
    //0
    class func showOnView(_ view:UIView) -> CalendarView{
  
        let calendarPicker = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?.first as! CalendarView
        view.addSubview(calendarPicker)
        return calendarPicker
    }
    //2
    override func draw(_ rect: CGRect) {
  
        addSwipe()
        show()
        
    }
    //1
    override func awakeFromNib() {
        //customInterface()
        weekDayArr = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    }
    func setMyDate(_ date:Date){
        self.date = date
        self.monthLabel.text = "\(self.month(date))-\(self.year(date))"
        self.collectionView.reloadData()
    }
    
    func addSwipe(){
        let swipLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(nextAction))
        swipLeft.direction = .left
        self.addGestureRecognizer(swipLeft)
        
        let swipRight = UISwipeGestureRecognizer.init(target: self, action: #selector(previousAction))
        swipRight.direction = .right
        self.addGestureRecognizer(swipRight)
   
    }
    func show(){
        self.transform = self.transform.translatedBy(x: 0, y: -self.frame.size.height)
        UIView.animate(withDuration: 0.5, animations: {
            //对动画设置量进行还原
            self.transform = CGAffineTransform.identity
            }, completion: { (isFinished) in
                self.customInterface()
                
        }) 
    
    
    }
    func customInterface(){
        //print(collectionView.frame)
        let itemWidth = collectionView.frame.size.width / 7
        let itemHeight = collectionView.frame.size.height / 7
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalendarCollectionViewCell.self,forCellWithReuseIdentifier: "cell")
       
    }
    
    
    func hide(){
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = self.transform.translatedBy(x: 0, y: -self.frame.size.height)
            }, completion: { (isFinished) in
                //self.mask.removeFromSuperview()
                self.removeFromSuperview()
        }) 
    }
    //右划
    func nextAction(){
        UIView.transition(with: self, duration: 0.5, options: .transitionCurlUp, animations: {
            self.setMyDate(self.nextMonth(self.date))
            }, completion: nil)
    
    }
    //左划
    func previousAction(){
        UIView.transition(with: self, duration: 0.5, options: .transitionCurlDown, animations: {
            self.setMyDate(self.lastMonth(self.date))
            }, completion: nil)
    
    }
    func nextMonth(_ date:Date) -> Date{
        var dateComponents = DateComponents.init()
        dateComponents.month = 1
        let newDate = (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: NSCalendar.Options.init(rawValue: 0))
        print(newDate)
        return newDate!
    }
    func lastMonth(_ date:Date) -> Date{
        var dateComponents = DateComponents.init()
        dateComponents.month = -1
        let newDate = (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: NSCalendar.Options.init(rawValue: 0))
        return newDate!
    }
    
    //MARK: collectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0{
            return weekDayArr.count
        }else{
            return 42
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCollectionViewCell
        //得到星期
        if indexPath.section == 0 {
            cell.getDataLabel().text = weekDayArr[indexPath.row]
            cell.getDataLabel().textColor = UIColor.orange
            
            
        //每个月的天
        }else{
            
            let dayInThisMonth = self.totalDaysInMonth(self.date)
            let firstWeekday = self.firstWeekdayInThisMonth(self.date)
            var day = 0
            
            if indexPath.row < firstWeekday {
                cell.getDataLabel().text = ""
                cell.backgroundColor = UIColor.clear
            }else if indexPath.row > firstWeekday + dayInThisMonth - 1{
                cell.getDataLabel().text = ""
                cell.backgroundColor = UIColor.clear
            }else{
                cell.backgroundColor = UIColor.clear
                day = indexPath.row - firstWeekday + 1
                cell.getDataLabel().text = "\(day)"
                cell.getDataLabel().textColor = UIColor.black
                //当天
                
                if self.today.compare(self.date) == ComparisonResult.orderedSame {
                    if day == self.day(self.date){
                        cell.getDataLabel().textColor = UIColor.red
                    }else if day > self.day(self.date){
                        cell.getDataLabel().textColor = UIColor.gray
                    }
                }else if self.today.compare(self.date) == .orderedAscending{
                    cell.getDataLabel().textColor = UIColor.gray
                }
            }
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.hide()
    }
    //一个月的总天数
    func totalDaysInMonth(_ date:Date) -> Int{
        let daysInLastMonth = (Calendar.current as NSCalendar).range(of: .day, in: .month, for: date)
        return daysInLastMonth.length
    }
    //获取该月第一个工作日的星期
    func firstWeekdayInThisMonth(_ date:Date) -> Int{
        var calendar = Calendar.current
        //指定日历的每周的第一天是从周几开始，1表示从周日开始
        calendar.firstWeekday = 1
        let unit = NSCalendar.Unit.year.rawValue | NSCalendar.Unit.month.rawValue | NSCalendar.Unit.day.rawValue
        //获取当前日期的年月日
        var comp = (calendar as NSCalendar).components(NSCalendar.Unit.init(rawValue: unit), from: date)
        //将日期的日改为本月的第一天
        comp.day = 1
        //通过datecomponent获得nsdate
        let firstDayOfMonthDate = calendar.date(from: comp)
        let firstWeekDay = (calendar as NSCalendar).ordinality(of: .weekday, in: .weekOfMonth, for: firstDayOfMonthDate!)
        return firstWeekDay - 1
    }
    
    //得到日期的天
    func day(_ date:Date) -> Int{
        let unit = NSCalendar.Unit.year.rawValue | NSCalendar.Unit.month.rawValue | NSCalendar.Unit.day.rawValue
        let components = (Calendar.current as NSCalendar).components(NSCalendar.Unit.init(rawValue: unit), from: self.date)
        return components.day!
    }
    //得到日期的月
    func month(_ date:Date) -> Int{
        let unit = NSCalendar.Unit.year.rawValue | NSCalendar.Unit.month.rawValue | NSCalendar.Unit.day.rawValue
        let components = (Calendar.current as NSCalendar).components(NSCalendar.Unit.init(rawValue: unit), from: self.date)
        return components.month!
    }
    //得到日期的年
    func year(_ date:Date) -> Int{
        let unit = NSCalendar.Unit.year.rawValue | NSCalendar.Unit.month.rawValue | NSCalendar.Unit.day.rawValue
        let components = (Calendar.current as NSCalendar).components(NSCalendar.Unit.init(rawValue: unit), from: self.date)
        return components.year!
    }

    

}
