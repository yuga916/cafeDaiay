//
//  DateManager.swift
//  FoodTracker
//
//  Created by 一戸悠河 on 2017/02/08.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit

extension Date {

class DateManager: NSObject {
    
    var currentMonthOfDates = [NSDate]() //表記する月の配列
    var selectedDate = NSDate()
    let daysPerWeek: Int = 7
    var numberOfItems: Int!
    
    //月ごとのセルの数を返すメソッド
    func daysAcquisition() -> Int {
         let rangeOfWeeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: firstDateOfMonth() as Date)
        let numberOfWeeks = Int((rangeOfWeeks?.count)!) //月が持つ週の数
        numberOfItems = numberOfWeeks * daysPerWeek //週の数×列の数
        return numberOfItems
    }
    //月の初日を取得
    func firstDateOfMonth() -> NSDate {
         var components = Calendar.current.dateComponents([.year, .month, .day], from:selectedDate as Date)
        components.day = 1
        let firstDateMonth = Calendar.current.date(from: components)!
        return firstDateMonth as NSDate
    }
    
    // ⑴表記する日にちの取得
    func dateForCellAtIndexPath(numberOfItems: Int) {
        // ①「月の初日が週の何日目か」を計算する
        let ordinalityOfFirstDay = Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth() as Date)
        // 修正前 for var i = 0; i < numberOfItems; i++ {
        for i in 0 ..< numberOfItems {
            // ②「月の初日」と「indexPath.item番目のセルに表示する日」の差を計算する
            let dateComponents = NSDateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay! - 1)
            // ③ 表示する月の初日から②で計算した差を引いた日付を取得
             let date = Calendar.current.date(byAdding: dateComponents as DateComponents, to: firstDateOfMonth() as Date)!            // ④配列に追加
            currentMonthOfDates.append(date as NSDate)
        }
    }
    
    // ⑵表記の変更
    func conversionDateFormat(indexPath: NSIndexPath) -> String {
        dateForCellAtIndexPath(numberOfItems: numberOfItems)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: currentMonthOfDates[indexPath.row] as Date)
    }

    }
}
