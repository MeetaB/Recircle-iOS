//
//  DatePickerViewController.swift
//  Recircle
//
//  Created by synerzip on 06/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DatePickerViewController: UIViewController{

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("datepicker")
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "DateCellView")
        
        calendarView.allowsMultipleSelection = true
        calendarView.rangeSelectionWillBeUsed = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

    extension DatePickerViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
        
        func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
            let myCustomCell = cell as! DayCellView
            
            // Setup Cell text
            myCustomCell.textDate.text = cellState.text
            
            
            
            // Setup text color
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.textDate.textColor = UIColor.black
            } else {
                myCustomCell.textDate.textColor = UIColor.gray
            }
        }

        func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        
            let myCustomCell = cell as! DayCellView
            
             myCustomCell.selectedView.layer.cornerRadius =  25
            
//            if cellState.isSelected {
//                myCustomCell.selectedView.isHidden = false
//            }
            
            switch cellState.selectedPosition() {
            case .full, .left, .right:
                myCustomCell.selectedView.isHidden = false
                myCustomCell.selectedView.backgroundColor = UIColor.yellow // Or you can put what ever you like for your rounded corners, and your stand-alone selected cell
            case .middle:
                myCustomCell.selectedView.isHidden = false
                myCustomCell.selectedView.backgroundColor = UIColor.blue // Or what ever you want for your dates that land in the middle
            default:
                myCustomCell.selectedView.isHidden = true
                myCustomCell.selectedView.backgroundColor = nil // Have no selection when a cell is not selected
            }
        }
        
        func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
            let myCustomCell = cell as! DayCellView
            myCustomCell.selectedView.isHidden = true
        }
        
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2016 02 01")! // You can use date generated from a formatter
        let endDate = Date()                                // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .sunday)
        return parameters
    }
}
