//
//  DayRangeSelectionTracker.swift
//  ijara
//
//  Created by Abduraxmon on 20/09/23.
//

import HorizonCalendar
import UIKit

enum DayRangeSelectionHelper {

  static func updateDayRange(afterTapSelectionOf day: Day, existingDayRange: inout DayRange?) {
    if
      let _existingDayRange = existingDayRange,
      _existingDayRange.lowerBound == _existingDayRange.upperBound,
      day > _existingDayRange.lowerBound
    {
      existingDayRange = _existingDayRange.lowerBound...day
    } else {
      existingDayRange = day...day
    }
  }

  static func updateDayRange(
    afterDragSelectionOf day: Day,
    existingDayRange: inout DayRange?,
    initialDayRange: inout DayRange?,
    state: UIGestureRecognizer.State,
    calendar: Calendar)
  {
    switch state {
    case .began:
      if day != existingDayRange?.lowerBound && day != existingDayRange?.upperBound {
        existingDayRange = day...day
      }
      initialDayRange = existingDayRange

    case .changed, .ended:
      guard let initialDayRange else {
        fatalError("`initialDayRange` should not be `nil`")
      }

      let startingLowerDate = calendar.date(from: initialDayRange.lowerBound.components)!
      let startingUpperDate = calendar.date(from: initialDayRange.upperBound.components)!
      let selectedDate = calendar.date(from: day.components)!

      let numberOfDaysToLowerDate = calendar.dateComponents(
        [.day],
        from: selectedDate,
        to: startingLowerDate).day!
      let numberOfDaysToUpperDate = calendar.dateComponents(
        [.day],
        from: selectedDate,
        to: startingUpperDate).day!

      if
        abs(numberOfDaysToLowerDate) < abs(numberOfDaysToUpperDate) ||
        day < initialDayRange.lowerBound
      {
        existingDayRange = day...initialDayRange.upperBound
      } else if
        abs(numberOfDaysToLowerDate) > abs(numberOfDaysToUpperDate) ||
        day > initialDayRange.upperBound
      {
        existingDayRange = initialDayRange.lowerBound...day
      }

    default:
      existingDayRange = nil
      initialDayRange = nil
    }
  }

}
