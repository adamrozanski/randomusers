//
//  TimeInterval+Extensions.swift
//  Users
//
//  Created by Adam on 25/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

extension TimeInterval {

    init?(signedHhmm: String) {
        self.init()
        let components = getComponents(from: signedHhmm)
        guard let interval = parseTimeInterval(from: components.hhmm) else {
            return nil
        }
        self = interval * (components.isNegative ? -1 : 1)
    }

    private func getComponents(from signedHhmm: String) -> (hhmm: String, isNegative: Bool) {
        let marker = (minus: "-", plus: "+")
        let isNegative: Bool = signedHhmm.contains(marker.minus)
        let characterToRemove: String = isNegative ? marker.minus : marker.plus
        let hhmm: String = signedHhmm.replacingOccurrences(of: characterToRemove, with: "")
        return (hhmm: hhmm, isNegative: isNegative)
    }

    private func parseTimeInterval(from hhmm: String, separator: String = ":") -> TimeInterval? {
        let unitMultipliers: [TimeInterval] = [60.0, 3600.0]
        var interval: TimeInterval = 0.0
        var timeComponents: [String] = hhmm.components(separatedBy: separator)
        timeComponents.reverse()
        guard timeComponents.count == unitMultipliers.count else {
            return nil
        }
        for index in 0..<timeComponents.count {
            guard let timeComponent = TimeInterval(timeComponents[index]) else {
                return nil
            }
            interval += timeComponent * unitMultipliers[index]
        }
        return interval
    }
}
