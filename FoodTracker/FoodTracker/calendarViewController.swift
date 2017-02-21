//
//  calendarViewController.swift
//  FoodTracker
//
//  Created by 一戸悠河 on 2017/02/08.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit
import FontAwesome_swift
import CoreData
import Photos

extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    }
}

class calendarViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Properties
    var cafeArray: [NSDictionary] = []
    var cafeDic: NSDictionary! = [:]
    var myCafe = NSArray() as! [String]

    
    let dateManager = DateManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 2.0
    var selectedDate = NSDate()
    var today: NSDate!
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    //テスト
    @IBOutlet weak var cafeLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    @IBOutlet weak var headerNextBtn: UIBarButtonItem!
    @IBOutlet weak var headerPrevBtn: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var coffeeFont: UILabel!
    @IBOutlet weak var timeFont: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.backgroundColor = UIColor.white
        
        // CollectionViewのレイアウトを生成.
        let layout = UICollectionViewFlowLayout()
        
        //コーヒーカップを出す
        coffeeFont.font = UIFont.fontAwesome(ofSize: 40)
//        myLabel.text = String.fontAwesomeIcon(name: .coffee) + "coffee"
        coffeeFont.text = String.fontAwesomeIcon(name: .coffee)
        
        //時計を出す
        timeFont.font = UIFont.fontAwesome(ofSize: 40)
        //        myLabel.text = String.fontAwesomeIcon(name: .coffee) + "coffee"
        timeFont.text = String.fontAwesomeIcon(name: .clockO)
        
        //編集ボタンを出す
         editButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        editButton.setTitle(String.fontAwesomeIcon(name: .edit), for: .normal)
        
        read()
        
        
    }
    
    //既に存在するデータの読み込み処理
    func read() {
        //AppDelegateを使う用意をする
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        //どのエンティティからdataを取得してくるか設定
        let query:NSFetchRequest<Diary> = Diary.fetchRequest()
        
        do{
            //データを一括取得
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "date")
            query.predicate = NSPredicate(format:"date = %@", selectedDate)
            let fetchResults = try viewContext.fetch(query)
        
            
            print(fetchResults.count)
            //            print(fetchResults)
            //データの取得
            //一旦配列を空っぽにする（初期化する）→そうしないとどんどん、TableViewに表示されてしまう。
            myCafe = NSArray() as! [String]
            //nilが入るかもしれないのでasに?をつける。
            for result: AnyObject in fetchResults {
                
                let coffeeName:String? = result.value(forKey: "coffeeName") as? String
                let date: Date? = result.value(forKey: "date") as? Date
                let studyTime: NSNumber = (result.value(forKey: "studyTime") as? NSNumber)!
                let img: String? = result.value(forKey: "img") as? String
                let rating: NSNumber? = result.value(forKey: "rating") as? NSNumber
                print("name:\(coffeeName) saveDate:\(date) studyTime:\(studyTime) image:\(img) rating:\(rating)")
                cafeDic = ["coffeeName":coffeeName, "date":date, "studyTime":studyTime, "img":img, "rating":rating]
                cafeArray.append(cafeDic)
                print(cafeArray)
                //                myCafe = NSArray() as! [String]
                //                myCafe.append(coffeeName!)
                //                print(myCafe)
                //下画面の変更
                cafeLabel.text = coffeeName
            }
        } catch {
        }
//        calendarView.reloadData()
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
        
//        let selectedDateTmp = selectMonth + "/" + dateManager.conversionDateFormat(indexPath: indexPath as NSIndexPath)
        let selectedDateTmp = selectMonth + "/" + dateManager.conversionDateFormat(indexPath: indexPath as NSIndexPath) + " 09:00:00 +0900" as! String
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
        
//        formatter.dateFormat = "yyyy/MM/dd"
//        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
//        var tmpDate = dateManager.conversionDateFormat(indexPath: indexPath as NSIndexPath) as! NSDate
        //時差を治す。
//        formatter.timeZone = TimeZone.current
        selectedDate = formatter.date(from: selectedDateTmp) as! NSDate
        print("Selected: \(selectedDate)")
        read()
    }
//    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        print("Num: \(indexPath.row)")
//        
//    }
    
    
    //Segueで画面遷移する時発動
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        //次の画面のオブジェクトを作成
        //destinationはAny型なので変換
        let secondVC = segue.destination as! MealViewController
        
        //選択されたkeyNameを次の画面のプロパティに保存
        secondVC.scSelectedDate = selectedDate
        print("日付\(secondVC.scSelectedDate)を次の画面へ渡す")
    }
    
    
    func changeHeaderTitle() -> String {
        let formatter: DateFormatter = DateFormatter()
        //let formatter = DateFormatter() //
        formatter.dateFormat = "M/yyyy"
        //formatter.string(from: date as Date)
        let selectMonth = formatter.string(from: selectedDate as Date)
        return selectMonth
    }
    
    //カレンダー下部の内容変更
    func changeContent() -> String {
        let formatter: DateFormatter = DateFormatter()
        //let formatter = DateFormatter() //
        formatter.dateFormat = "yyyy/MM/dd"
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
