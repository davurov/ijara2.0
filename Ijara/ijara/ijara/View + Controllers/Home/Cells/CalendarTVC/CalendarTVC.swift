//
//  CalendarTVC.swift
//  ijara
//
//  Created by Abduraxmon on 19/09/23.
//

import UIKit
import FSCalendar
import RollingDigitsLabel

protocol RangeDelegate {
    func rangeSelected(dates: [Date]?)
    func personAdded(num: Int)
}

class CalendarTVC: UITableViewCell {
    
    @IBOutlet weak var weakdayPrice: UILabel!
    @IBOutlet weak var workingDayPrice: UILabel!
    @IBOutlet weak var peopleTF: UITextField!
    @IBOutlet weak var peopleView: UIView!
    @IBOutlet weak var calendarCont: UIView!
    weak var calendarView: FSCalendar!
    
    static let identifier: String = String(describing: CalendarTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    private var firstDate: Date?
    private var lastDate: Date?
    var delegate: RangeDelegate?
    var datesRange: [Date]?
    var dateFormatter: DateFormatter!
    var sum = 1 {
        didSet {
            delegate?.personAdded(num: sum)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    
    func setUpViews() {
        let calendarView = FSCalendar(frame: CGRect(x: 0, y: 0, width: calendarCont.frame.width, height: 300))
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.allowsMultipleSelection = true
        calendarView.swipeToChooseGesture.isEnabled = true
        
        
        peopleTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        //calendarView.appearance.selectionColor = AppColors.mainColor
        calendarView.register(CalendarCVC.self, forCellReuseIdentifier: "cell")
        self.calendarView = calendarView
        self.calendarCont.addSubview(calendarView)
        peopleView.addBorder(size: 0.5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc func textFieldDidChange() {
        sum = Int(peopleTF.text ?? "1") ?? 1
    }
    
    @IBAction func minusPressed(_ sender: UIButton) {
        if sum > 1 {
            sum -= 1
            peopleTF.text = "\(sum)"
        }
    }
    
    
    @IBAction func plusPressed(_ sender: Any) {
        sum += 1
        peopleTF.text = "\(sum)"
    }
}

extension CalendarTVC: FSCalendarDataSource, FSCalendarDelegate, UIScrollViewDelegate {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        // Customize the appearance of calendar cells here
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position) as! CalendarCVC
        
        // Check if the date is in the past
        if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedAscending {
            // Date is in the past, make it partially transparent
            cell.titleLabel.alpha = 0.5
            
        } else {
            // Date is not in the past, reset alpha to 1.0
            cell.titleLabel.alpha = 1.0
        }
        //cell.backgroundColor = .white
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        // Check if the date is in the past
        if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedAscending {
            // Date is in the past, do not allow selection
            return false
        }
        // Date is not in the past, allow selection
        return true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            
            return
        }
        
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                
                return
            }
            
            let range = datesRange(from: firstDate!, to: date)
            
            lastDate = range.last
            
            for d in range {
                calendar.select(d)
            }
            
            datesRange = range
            delegate?.rangeSelected(dates: datesRange)
            
            return
        }
        
        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            firstDate = nil
            
            datesRange = []
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:
        
        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            firstDate = nil
            
            datesRange = []
        }
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
}
