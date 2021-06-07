//
//  CalenderVc.swift
//  Mad
//
//  Created by MAC on 03/06/2021.
//

import UIKit
import FSCalendar


class CalenderVc : UIViewController ,FSCalendarDataSource, FSCalendarDelegate{
    
    @IBOutlet weak var calendar: FSCalendar!
    var tag = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
            
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Y-M-d"
        let selectedDate: String = dateFormatter.string(from: date)
        print(selectedDate)
        if self.tag == 1{
            Helper.saveDate1(code: selectedDate)
        }else{
            Helper.saveDate2(code: selectedDate)
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Y-m-d"
        let selectedDate: String = dateFormatter.string(from: date)
        print(selectedDate)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
