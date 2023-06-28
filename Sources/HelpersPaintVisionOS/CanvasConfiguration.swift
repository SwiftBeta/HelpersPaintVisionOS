//
//  File.swift
//
//
//  Created by Home on 28/6/23.
//

import Foundation
import Observation
import SwiftUI

public class CanvasConfiguration: ObservableObject {
    @Published public var lines: [Line] = []
    @Published public var currentLineColor: Color = .blue
    @Published public var currentLineWidth: Float = 20.0
    
    required public init(lines: [Line] = [],
                currentLineColor: Color = .blue,
                currentLineWidth: Float = 20.0) {
        self.lines = lines
        self.currentLineColor = currentLineColor
        self.currentLineWidth = currentLineWidth
    }
    
    public func removeAll() {
        lines.removeAll()
    }
}
