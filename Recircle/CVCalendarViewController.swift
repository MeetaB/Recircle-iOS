//
//  CVCalendarViewController.swift
//  Recircle
//
//  Created by synerzip on 07/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import CVCalendar

class CVCalendarViewController: UIViewController {

    @IBOutlet weak var calendarView: CVCalendarView!
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        menuView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
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

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate
extension CVCalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .sunday
}
}
