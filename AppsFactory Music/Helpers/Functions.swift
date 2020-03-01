//
//  Functions.swift
//  AppsFactory Music
//
//  Created by Arsalan Iravani on 27/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import Foundation
import UIKit

/// Return separately minutes and seconds
/// - Parameter seconds: number of seconds to convert
func returnDurationFormat(fromSeconds seconds: Int) -> (minutes: Int, seconds: Int) {
    return (seconds / 60, seconds % 60)
}
