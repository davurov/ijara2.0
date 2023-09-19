//
//  CalendarTVC.swift
//  ijara
//
//  Created by Abduraxmon on 19/09/23.
//

import UIKit
import HorizonCalendar

class CalendarTVC: UITableViewCell {
    
    static let identifier: String = String(describing: CalendarTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var calendarView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    
    func setUpViews() {
        let calView = CalendarView(initialContent: makeContent())
        
        calendarView.addSubview(calView)

        calendarView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            calView.leadingAnchor.constraint(equalTo: calendarView.layoutMarginsGuide.leadingAnchor),
            calView.trailingAnchor.constraint(equalTo: calendarView.layoutMarginsGuide.trailingAnchor),
            calView.topAnchor.constraint(equalTo: calendarView.layoutMarginsGuide.topAnchor),
            calView.bottomAnchor.constraint(equalTo: calendarView.layoutMarginsGuide.bottomAnchor),
        ])
        
    }
    
    private func makeContent() -> CalendarViewContent {
      let calendar = Calendar.current

      let startDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 01))!
      let endDate = calendar.date(from: DateComponents(year: 2021, month: 12, day: 31))!

      return CalendarViewContent(
        calendar: calendar,
        visibleDateRange: startDate...endDate,
        monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
