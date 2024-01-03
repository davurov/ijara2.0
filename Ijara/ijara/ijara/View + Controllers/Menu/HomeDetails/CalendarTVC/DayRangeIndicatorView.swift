//
//  DayRangeIndicatorView.swift
//  ijara
//
//  Created by Abduraxmon on 20/09/23.
//

import HorizonCalendar
import UIKit

final class DayRangeIndicatorView: UIView {

  // MARK: Lifecycle

  fileprivate init(indicatorColor: UIColor) {
    self.indicatorColor = indicatorColor

    super.init(frame: .zero)

    backgroundColor = .clear
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(indicatorColor.cgColor)

    if traitCollection.layoutDirection == .rightToLeft {
      context?.translateBy(x: bounds.midX, y: bounds.midY)
      context?.scaleBy(x: -1, y: 1)
      context?.translateBy(x: -bounds.midX, y: -bounds.midY)
    }

    // Get frames of day rows in the range
    var dayRowFrames = [CGRect]()
    var currentDayRowMinY: CGFloat?
    for dayFrame in framesOfDaysToHighlight {
      if dayFrame.minY != currentDayRowMinY {
        currentDayRowMinY = dayFrame.minY
        dayRowFrames.append(dayFrame)
      } else {
        let lastIndex = dayRowFrames.count - 1
        dayRowFrames[lastIndex] = dayRowFrames[lastIndex].union(dayFrame)
      }
    }

    // Draw rounded rectangles for each day row
    for dayRowFrame in dayRowFrames {
      let cornerRadius = dayRowFrame.height / 2
      let roundedRectanglePath = UIBezierPath(roundedRect: dayRowFrame, cornerRadius: cornerRadius)
      context?.addPath(roundedRectanglePath.cgPath)
      context?.fillPath()
    }
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setNeedsDisplay()
  }

  // MARK: Fileprivate

  fileprivate var framesOfDaysToHighlight = [CGRect]() {
    didSet {
      guard framesOfDaysToHighlight != oldValue else { return }
      setNeedsDisplay()
    }
  }

  // MARK: Private

  private let indicatorColor: UIColor

}

// MARK: CalendarItemViewRepresentable

extension DayRangeIndicatorView: CalendarItemViewRepresentable {

  struct InvariantViewProperties: Hashable {
    var indicatorColor = UIColor(.accentColor.opacity(0.3))
  }

  struct Content: Equatable {
    let framesOfDaysToHighlight: [CGRect]
  }

  static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> DayRangeIndicatorView
  {
    DayRangeIndicatorView(indicatorColor: invariantViewProperties.indicatorColor)
  }

  static func setContent(_ content: Content, on view: DayRangeIndicatorView) {
    view.framesOfDaysToHighlight = content.framesOfDaysToHighlight
  }

}
