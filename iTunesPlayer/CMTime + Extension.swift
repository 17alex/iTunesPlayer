//
//  CMTime + Extension.swift
//  iTunesPlayer
//
//  Created by Alex on 30.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "--:--"}
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        return timeString
    }
}
