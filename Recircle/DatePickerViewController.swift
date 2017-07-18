//
//  DatePickerViewController.swift
//  Recircle
//
//  Created by synerzip on 06/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import JTAppleCalendar

struct CalendarState {
    static var startDate : Date!
    static var endDate : Date!
    static var productDetail : Bool = false
    static var searchProduct : Bool = false
    static var searchResult : Bool = false
    static var listItem : Bool = false
    static var listItemSummary : Bool = false
    static var unavailableDates : [String] = []
}


class DatePickerViewController: UIViewController {


    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var textStartDate: UILabel!
    
    @IBOutlet weak var textEndDate: UILabel!
    
    @IBOutlet weak var btnReset: UIButton!
    
    var currentCalendar: Calendar?
    
    var delegates : SearchViewController?
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var calendarColor : UIColor!
    
    public var rentItem : RentItem!
    
    var unavailableDates : [String] = []
    
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("datepicker")
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "DateCellView")
        calendarView.registerHeaderView(xibFileNames: ["HeaderView"])
        
        calendarView.scrollDirection = .vertical
        
        calendarView.itemSize = 30.0
        
        calendarView.allowsMultipleSelection = true
       
        // Do any additional setup after loading the view.
        
        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
        panGensture.minimumPressDuration = 0.5
        calendarView.addGestureRecognizer(panGensture)
        calendarView.rangeSelectionWillBeUsed = true
    
        
        calendarView.isHidden = false
        
        if #available(iOS 10.0, *) {
            calendarColor = UIColor(red: 0, green: 151/255, blue: 167/255, alpha: 0)
        } else {
            // Fallback on earlier versions
        }
    
        
        if CalendarState.listItemSummary {
            
            btnSave.isHidden = true
            
            textStartDate.isHidden = true
            
            textEndDate.isHidden = true
            
            btnReset.isHidden = true
            
            var datesSelect : [Date] = []
            
            for dateString in CalendarState.unavailableDates {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'00:00:00.000'Z'"
                let date = formatter.date(from: dateString)
                datesSelect.append(date!)
            }
            
            calendarView.selectDates(datesSelect, triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: false)
        
           
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         CalendarState.listItemSummary = false
    }
    
    @IBAction func resetButtonPressed(_ sender: AnyObject) {
        calendarView.deselectAllDates()
        rangeSelectedDates.removeAll()
        textStartDate.text = "Start Date"
        textEndDate.text = "End Date"
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goBack" {
           let vc = segue.destination as! SearchViewController
                
            vc.searchFromDate = rangeSelectedDates.first
            vc.searchToDate = rangeSelectedDates.last
        }
        else if segue.identifier == "searchResult" {
        
            let searchVC = segue.destination as! SearchViewController
            searchVC.dateText = textStartDate.text! + " - " + textEndDate.text!
            
        }
        
        else if segue.identifier == "rentSummary" {
            let rentSummaryVC = segue.destination as! RentSummaryViewController
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'00:00:000'Z'"
            rentItem.order_from_date = formatter.string(from: rangeSelectedDates.first!)
            rentItem.order_to_date = formatter.string(from: rangeSelectedDates.last!)
            rentItem.duration = rangeSelectedDates.count
            rentSummaryVC.rentItem = rentItem
//            self.navigationController?.pushViewController(testVC, animated: true)
            
            
        }
        
        
    }
    
    var rangeSelectedDates: [Date] = []
    func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        rangeSelectedDates = calendarView.selectedDates
        if let cellState = calendarView.cellStatus(at: point) {
            let date = cellState.date
            if !rangeSelectedDates.contains(date) {
                let dateRange = calendarView.generateDateRange(from: rangeSelectedDates.first ?? date, to: date)
                for aDate in dateRange {
                    if !rangeSelectedDates.contains(aDate) {
                        rangeSelectedDates.append(aDate)
                    }
                }
                calendarView.selectDates(from: rangeSelectedDates.first!, to: date, keepSelectionIfMultiSelectionAllowed: true)
            } else {
                let indexOfNewlySelectedDate = rangeSelectedDates.index(of: date)! + 1
                let lastIndex = rangeSelectedDates.endIndex
                let testcalendar = Calendar.current
                let followingDay = testcalendar.date(byAdding: .day, value: 1, to: date)!
                calendarView.selectDates(from: followingDay, to: rangeSelectedDates.last!, keepSelectionIfMultiSelectionAllowed: false)
                rangeSelectedDates.removeSubrange(indexOfNewlySelectedDate..<lastIndex)
            }
            //
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            textStartDate.text = formatter.string(from: (rangeSelectedDates.first)!)
            textEndDate.text = formatter.string(from: (rangeSelectedDates.last)!)
            formatter.dateFormat = "yyyy-MM-dd'T'00:00:00.000Z"
            let startDate = formatter.string(from: rangeSelectedDates.first!)
            CalendarState.startDate =  formatter.date(from: startDate)
             let endDate = formatter.string(from: rangeSelectedDates.last!)
            CalendarState.endDate = formatter.date(from: endDate)
            //
        }
        
//        if gesture.state == .ended {
//            rangeSelectedDates.removeAll()
//        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
        print("unwind for datepicker")

        if unwindSegue.identifier == "datePicker" {
            print("data")
        }
        
    }
    
    @IBAction func unwindToSearch(segue: UIStoryboardSegue){
        print("unwind datepicker")
    }

    
   
    @IBAction func saveDates(_ sender: AnyObject) {
        
        if CalendarState.productDetail {
            _ = self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "rentSummary", sender: self)
            CalendarState.productDetail = false
        } else if CalendarState.listItem {
            CalendarState.unavailableDates = self.unavailableDates
            CalendarState.listItem = false
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.dismiss(animated: true) {
                
            }

        }
        
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
        
        // MARK: - JTAppleCalendar Header setup
        // Height of the header
        func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
            return CGSize(width: 200, height: 40)
        }
        
    
        // Text format of the header
        func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
            let headerCell = (header as? HeaderView)
            formatter.dateFormat = "MMMM yyyy"
            if #available(iOS 10.0, *) {
                headerCell?.backgroundColor = UIColor(red: 0, green: 151/255, blue: 167/255, alpha: 0)
            } else {
                // Fallback on earlier versions
            }
            headerCell?.title.textColor = UIColor.white
            headerCell?.title.text = formatter.string(from: range.end)
        }
        
        func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
            
            
            
//            
//            if cellState.isSelected {
//                myCustomCell.selectedView.backgroundColor = UIColor.white
//                myCustomCell.textDate.textColor = UIColor(displayP3Red: 0, green: 151, blue: 167, alpha: 0)
//            } else {
//                myCustomCell.textDate.textColor = UIColor.white
//            }
          
            handleCellTextColor(view: cell, cellState: cellState)
            handleCellSelection(view: cell, cellState: cellState)
            let myCustomCell = cell as! DayCellView
            //
            myCustomCell.backgroundColor = calendarColor
            //            // Setup Cell text
            myCustomCell.textDate.text = cellState.text
            
            // Setup text color
//            if cellState.dateBelongsTo == .thisMonth {
//                myCustomCell.textDate.textColor = UIColor.white
//            } else {
//                myCustomCell.textDate.textColor = UIColor.gray
//            }
        }

        func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        
            //change dateformat
            if CalendarState.listItem {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'00:00:00.000'Z'"
                let dateString = formatter.string(from: date)
                unavailableDates.append(dateString)
            }
            
            handleCellSelection(view: cell, cellState: cellState)
            handleCellTextColor(view: cell, cellState: cellState)
    

        }
        
        // Function to handle the text color of the calendar
        func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
            
            guard let myCustomCell = view as? DayCellView  else {
                return
            }
            
            if cellState.date.compare(Date()) == .orderedAscending || cellState.dateBelongsTo != .thisMonth
            {
                myCustomCell.textDate.textColor = UIColor.gray
            }
 
            if Calendar.current.isDateInToday(cellState.date) {
                myCustomCell.textDate.backgroundColor = UIColor.white
                myCustomCell.textDate.textColor = UIColor.blue
            }
                
            else {
            if cellState.isSelected {
                myCustomCell.textDate.textColor = UIColor.black
            } else {
                
                if cellState.dateBelongsTo == .thisMonth {
                    myCustomCell.textDate.textColor = UIColor.white
                } else {
                    myCustomCell.textDate.textColor = UIColor.gray
                }
                
                if cellState.date.compare(Date()) == .orderedAscending
                {
                    myCustomCell.textDate.textColor = UIColor.lightGray
                }
                
                if Calendar.current.isDateInToday(cellState.date) {
                    myCustomCell.textDate.backgroundColor = UIColor.black
                } else {
                    if #available(iOS 10.0, *) {
                        myCustomCell.textDate.backgroundColor = UIColor(red: 0, green: 151/255, blue: 167/255, alpha: 0)
                    } else {
                        // Fallback on earlier versions
                    }
                }

               
                }
            }
        }
        
        // Function to handle the calendar selection
        func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
            guard let myCustomCell = view as? DayCellView  else {
                return
            }
            
            if cellState.date.compare(Date()) == .orderedAscending || cellState.dateBelongsTo != .thisMonth
            {
                myCustomCell.selectedView.isHidden = true
                myCustomCell.cross.isHidden = true
            }
            else {
            if cellState.isSelected {
                myCustomCell.selectedView.layer.cornerRadius =  10
                myCustomCell.selectedView.isHidden = false
                if CalendarState.listItem || CalendarState.listItemSummary {
                    myCustomCell.cross.isHidden = false
                } else {
                    myCustomCell.cross.isHidden = true
                }
            } else {
                myCustomCell.selectedView.isHidden = true
                myCustomCell.cross.isHidden = true
            }
            }
        }
        
        func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleDayCellView, cellState: CellState) -> Bool {
            if CalendarState.listItemSummary {
                return false
            } else {
                return true
            }
        }
        
        func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleDayCellView, cellState: CellState) -> Bool {
            if CalendarState.listItemSummary {
                return false
            } else {
                return true
            }
        }
        
        
        
        func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        //    let myCustomCell = cell as! DayCellView
           // myCustomCell.selectedView.isHidden = true
            
            //change dateformat
            if CalendarState.listItem {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'00:00:000'Z'"
                let dateString = formatter.string(from: date)
                
                if unavailableDates.contains(dateString) {
                    unavailableDates.remove(at: unavailableDates.index(of: dateString)!)
                }
            }
            
            handleCellSelection(view: cell, cellState: cellState)
            handleCellTextColor(view: cell, cellState: cellState)
            
        }
        
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = Date()
      //  let startDate = formatter.date(from: "2016 02 01")! // You can use date generated from a formatter
        let endDate = formatter.date(from: "2068 01 01")!                               // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .off,
            firstDayOfWeek: .sunday)
        
        
        print(startDate)
        print(Calendar.current)
        return parameters
    }
}
