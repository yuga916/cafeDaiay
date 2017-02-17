//
//  calendarViewController.swift
//  FoodTracker
//
//  Created by 一戸悠河 on 2017/02/08.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit

extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    }
}

class calendarViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let dateManager = DateManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 2.0
    var selectedDate = NSDate()
    var today: NSDate!
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    @IBOutlet weak var calenderCollectionView: UICollectionView!
    @IBOutlet weak var headerNextBtn: UIBarButtonItem!
    @IBOutlet weak var headerPrevBtn: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.backgroundColor = UIColor.white
        
        // CollectionViewのレイアウトを生成.
        let layout = UICollectionViewFlowLayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    //2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの総数を変える.
        if section == 0 {
            return 7
        } else {
            return dateManager.daysAcquisition() //ここは月によって異なる(後ほど説明します)
        }
    }
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CalendarCell
        //テキストカラー
        if (indexPath.row % 7 == 0) {
            cell.textLabel.textColor = UIColor.lightRed()
        } else if (indexPath.row % 7 == 6) {
            cell.textLabel.textColor = UIColor.lightBlue()
        } else {
            cell.textLabel.textColor = UIColor.gray
        }
        //テキスト配置
        if indexPath.section == 0 {
            cell.textLabel.text = weekArray[indexPath.row]
        } else {
            cell.textLabel.text = dateManager.conversionDateFormat(indexPath: indexPath as NSIndexPath)
            //月によって1日の場所は異なる(後ほど説明します)
        }
        return cell
    }
    
    //セルのサイズを設定
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let numberOfMargin: CGFloat = 8.0
        let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        let height: CGFloat = width * 1.0
        return CGSize(width:width, height:height)
        
    }
    
    //セルの垂直方向のマージンを設定
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin
    }
    
    //セルの水平方向のマージンを設定
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin
    }
    
    //cellが選択された時のアクション
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Selected: \(selectedDate)")
        print(dateManager.conversionDateFormat(indexPath: indexPath as NSIndexPath))
        
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        
        formatter.dateFormat = "yyyy/MM"
        //formatter.string(from: date as Date)
        
        let selectMonth = formatter.string(from: selectedDate as Date)
        
        let selectedDateTmp = selectMonth + "/" + dateManager.conversionDateFormat(indexPath: indexPath as NSIndexPath)
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
//        var tmpDate = dateManager.conversionDateFormat(indexPath: indexPath as NSIndexPath) as! NSDate
        //時差を治す。
//        formatter.timeZone = TimeZone.current
        selectedDate = formatter.date(from: selectedDateTmp) as! NSDate
        print("Selected: \(selectedDate)")
    }
//    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        print("Num: \(indexPath.row)")
//        
//    }
    
    
    
    func changeHeaderTitle() -> String {
        let formatter: DateFormatter = DateFormatter()
        //let formatter = DateFormatter() //
        formatter.dateFormat = "M/yyyy"
        //formatter.string(from: date as Date)
        let selectMonth = formatter.string(from: selectedDate as Date)
        return selectMonth
    }

    
    @IBAction func tappedHeaderPrevBtn(_ sender: UIButton) {
        selectedDate = dateManager.prevMonth(date: selectedDate as Date) as NSDate
        calenderCollectionView.reloadData()
        //(date: selectedDate)
        navigationBar.title = changeHeaderTitle()
    }
    
    @IBAction func tappedHeaderNextBtn(_ sender: UIButton) {
        selectedDate = dateManager.nextMonth(date: selectedDate as Date) as NSDate
        calenderCollectionView.reloadData()
        //(date: selectedDate)
        navigationBar.title = changeHeaderTitle()
    }
}
